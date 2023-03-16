import ballerinax/googleapis.sheets as sheets;

sheets:ConnectionConfig spreadsheetConfig = {
    auth: {
            clientId: "598963914155-ehibv1e8djs3ceji42t1829psfk6bvs8.apps.googleusercontent.com",
            clientSecret: "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",
            refreshUrl: "https://www.googleapis.com/oauth2/v3/token",
            refreshToken: "1//04IN09vwXMq4DCgYIARAAGAQSNwF-L9IrBl5KZmTCurdtGACvZKklh-vasUGPN29dIN8Aba9uT0fwRQcUOHstjeET-9OBVTORjCo"
        }
 };

sheets:Client spreadsheetClient = check new (spreadsheetConfig);

public function writeToSheet(int row, string[] userClaims) returns error? {
        error? updateData = check spreadsheetClient->createOrUpdateRow("1goI1Ddz9mBIDKtSojDDDOSZBY9A9pnzXnDJIMvVmMcU","Sheet1", row, userClaims);
}
