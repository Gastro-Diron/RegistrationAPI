import ballerina/email;

public function sendEmail(string toemail, string verificationCode) returns string|error {
    email:SmtpClient smtpClient = check new ("smtp.gmail.com", "dironag2000@gmail.com" , "mosmwsupnjlunxiv");
    email:Message email = {
        to: [toemail],
        subject: "Verification Email",
        body: "Please enter this code in the application UI to verify your email address:" +
        "Your code is "+verificationCode,
        'from: "dironag2000@gmail.com"
    };
    check smtpClient->sendMessage(email);
    return verificationCode;
}

public function success(string toemail) returns error?{
    email:SmtpClient smtpClient = check new ("smtp.gmail.com", "dironag2000@gmail.com" , "mosmwsupnjlunxiv");
    email:Message email = {
        to: [toemail],
        subject: "Account Creation Confirmation Email",
        body: "Please paste the following url to enter your password and complete your registration. https://localhost:5501/password.html ",
        'from: "dironag2000@gmail.com"
    };
    check smtpClient->sendMessage(email);
}

public function failure(string toemail) returns error?{
    email:SmtpClient smtpClient = check new ("smtp.gmail.com", "dironag2000@gmail.com" , "mosmwsupnjlunxiv");
    email:Message email = {
        to: [toemail],
        subject: "Account Creation Failure Email",
        body: "Sorry, the code you have entered is invalid",
        'from: "dironag2000@gmail.com"
    };
    check smtpClient->sendMessage(email);
}