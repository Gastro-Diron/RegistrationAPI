import ballerina/email;
// import ballerina/random;

// int randomInteger = check random:createIntInRange(1000, 9999);
// string verificationCode = randomInteger.toString();
string verificationCode = "1234";

public function sendEmail(string toemail) returns string|error {
    email:SmtpClient smtpClient = check new ("smtp.gmail.com", "gastrodironalexander@gmail.com" , "jmsrwgdnaewcfvoj");
    email:Message email = {
        to: [toemail],
        subject: "Verification Email",
        body: "Please enter this code in the application UI to verify your email address:" +
        "Your code is "+verificationCode,
        'from: "gastrodironalexander@gmail.com"
    };
    check smtpClient->sendMessage(email);
    return verificationCode;
}
