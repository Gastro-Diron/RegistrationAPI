import ballerina/email;
import flow1.codegen;

public string verificationCode = check codegen:genCode();

public function sendEmail(string toemail) returns string|error {
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
