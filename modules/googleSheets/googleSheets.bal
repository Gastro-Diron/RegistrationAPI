import ballerinax/googleapis.sheets as sheets;
import ballerina/io;

configurable string clientID = io:readln("Input ClientID:");
configurable string clientSecert = io:readln("Input ClientSecret:");
configurable string refreshToken = io:readln("Input refreshToken:");
configurable string sheetID = io:readln("Input spreadsheetID:");

sheets:ConnectionConfig spreadsheetConfig = {
    auth: {
            clientId: clientID,
            clientSecret: clientSecert,
            refreshUrl: "https://www.googleapis.com/oauth2/v3/token",
            refreshToken: refreshToken
        }
 };

sheets:Client spreadsheetClient = check new (spreadsheetConfig);

public function writeToSheet(int row, string[] userClaims) returns error? {
        error? updateData = check spreadsheetClient->createOrUpdateRow(sheetID,"Sheet1", row, userClaims);
}

public function getData() returns error|sheets:Row {
        sheets:Row|error openRes = check spreadsheetClient->getRow(sheetID,"Sheet1",1);
        return openRes;
}

public function updatePassword(string password) returns error?{
        error? updateCell = check spreadsheetClient->setCell(sheetID,"Sheet1", "E1", password);
}

public function deleteCell() returns error?{
        error? emptyCell = check spreadsheetClient->clearCell(sheetID,"Sheet1", "E1");
}