import ballerina/http;
import flow1.email;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;
// import ballerina/io;

int Rownum = 1;
mysql:Client dbClient = check new ("sql12.freesqldatabase.com", "sql12607670", "Kp4bevX1b8", "sql12607670", 3306);

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
            string|error mailer  = email:sendEmail(toemail);
            User newEntry = {...userEntry, code: check mailer};
            userTable.add(newEntry);
            error? data = createUser(newEntry.email, newEntry.name, newEntry.country, newEntry.code);
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


function createUser(string email, string name, string country, string code) returns error?{
    sql:ParameterizedQuery query = `INSERT INTO TemporaryUserStore(email, name, country, code)
                                  VALUES (${email}, ${name}, ${country}, ${code})`;
    sql:ExecutionResult result = check dbClient->execute(query);
}
