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
