import ballerina/email;
string verificationCode = "1234";

public function sendEmail(string toemail) returns string|error {
    email:SmtpClient smtpClient = check new ("smtp.gmail.com", "agderon@gmail.com" , "wviwqvxxvxvprgug");
    email:Message email = {
        to: [toemail],
        subject: "Verification Email",
        body: "Please enter this code in the application UI to verify your email address:" +
        "Your code is "+verificationCode,
        'from: "agderon@gmail.com"
    };
    check smtpClient->sendMessage(email);
    return verificationCode;
}
