import ballerina/http;
import flow1.email;
import flow1.googleSheets;

int Rownum = 1;

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
            User newEntry = {...userEntry, code:check mailer};
            userTable.add(newEntry);
            error? tempUserStore = googleSheets:writeToSheet(Rownum,newEntry.toArray());
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
