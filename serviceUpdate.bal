import ballerina/http;
import flow1.email;
import flow1.googleSheets;
import flow1.codegen;
import ballerina/io;
import flow1.formatData;
import ballerinax/googleapis.sheets;

int Row = 1;
string scope = "internal_user_mgt_create";
string orgname = "orgwso2";

configurable string clientID = io:readln("Enter the ClientID of your Asgardeo Application:");
configurable string clientSecret = io:readln("Enter the ClientSecret of your Asgardeo Application:");

http:Client Register = check new ("https://api.asgardeo.io/t/orgwso2/scim2", httpVersion = http:HTTP_1_1);

service /flow1 on new http:Listener (9090){
    resource function get users() returns User[] {
        return userTable.toArray();
    }
    
    resource function post users (@http:Payload UserEntry userEntry) returns UserEntry|ConflictingEmailsError|error {
        boolean conflictingEmail = userTable.hasKey(userEntry.email);
        string toemail = userEntry.email;

        if conflictingEmail {
            return {
                body: {
                    errmsg: string:'join(" ", "Conflicting emails:"+userEntry.email)
                }
            };
        } else {
            string verificationCode = check codegen:genCode();
            string|error mailer  = email:sendEmail(toemail,verificationCode);
            User newEntry = {...userEntry, code: check mailer};
            userTable.add(newEntry);
            error? emptysheet = googleSheets:deleteCell();
            error? tempUserStore = googleSheets:writeToSheet(Row,newEntry.toArray());
            return userEntry;
        }
    }

    resource function get users/[string email] () returns User|InvalidEmailError {
        User? userEntry = userTable[email];
        if userEntry is () {
            return {
                body: {
                    errmsg: string `Invalid Email: ${email}`
                }
            };
        }
        return userEntry;
    }

    resource function post users/[string email] (string password) returns string|InvalidEmailError|error{
        User? userEntry = userTable[email];
        sheets:Row data = check googleSheets:getData();
        FullUser newEntry;

        if userEntry is () {
            return {
                body: {
                    errmsg: string `Invalid Email: ${email}`
                }
            };
        } else {
            newEntry = {...userEntry, password:password};
            error? tempUserStore = googleSheets:updatePassword(password);
            json Msg = formatData:formatdata(data.values[2],data.values[1],password);

            error? success = email:success(email);

            json token = check makeRequest(orgname,clientID,clientSecret);
            json token_type_any = check token.token_type;
            json access_token_any = check token.access_token;
            string token_type = token_type_any.toString();
            string access_token = access_token_any.toString();
            http:Response|http:ClientError postData = check Register->post(path = "/Users", message = Msg, headers = {"Authorization": token_type+" "+access_token, "Content-Type": "application/scim+json"});
            if postData is http:Response {
                int num = postData.statusCode;
                return "The code is correct. The statusCode is "+num.toString();
            } else {
                return "The code is correct but error in creating the user";
            }
        }
        //return newEntry;
    }
}

public type UserEntry record {|
    readonly string email;
    string name;
    string country;
|};

public type User record {|
    *UserEntry;
    string code;
|};

public final table <User> key(email) userTable = table [
    {email: "summa@gmail.com", name: "Gastro Diron", country: "SriLanka", code: "1234"}
];

public type FullUser record {|
    *User;
    string password;
|};

public type ConflictingEmailsError record {|
    *http:Conflict;
    ErrorMsg body;
|};

public type ErrorMsg record {|
    string errmsg;
|};

public type InvalidEmailError record {|
    *http:NotFound;
    ErrorMsg body;
|};

public function makeRequest(string orgName, string clientId, string clientSecret) returns json|error|error {
    http:Client clientEP = check new ("https://api.asgardeo.io",
        auth = {
            username: clientId,
            password: clientSecret
        },
         httpVersion = http:HTTP_1_1
    );
    http:Request req = new;
    req.setPayload("grant_type=client_credentials&scope="+scope, "application/x-www-form-urlencoded");
    http:Response response = check clientEP->/t/[orgName]/oauth2/token.post(req);
    io:println("Got response with status code: ", response.statusCode);
    io:println(response.getJsonPayload());
    json tokenInfo = check response.getJsonPayload();
    return tokenInfo;
}