import ballerina/log;
import ballerinax/googleapis.sheets as sheets;

sheets:ConnectionConfig spreadsheetConfig = {
    auth: {
            clientId: "471759866028-m78a6pekebvk1ebt0vi6c0m8gp7r4riq.apps.googleusercontent.com",
            clientSecret: "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",
            refreshUrl: "https://www.googleapis.com/oauth2/v3/token",
            refreshToken: "1//04QbPUaOoFnyKCgYIARAAGAQSNwF-L9Irmc0G1KY8RhV7NAYADqFmsxgJdZ7SyQJvGoEYgHONOc-uKAjZlyrmuKrQGcUIGE9y6fA"
        }
 };

sheets:Client spreadsheetClient = check new (spreadsheetConfig);

public function writeToSheet(int row, string[] userClaims) returns error? {
        error? updateData = check spreadsheetClient->createOrUpdateRow("15ZwaqMQDHNmTxUTSV51Q96oSw92sWr_dIL6cJOjx3w0","Sheet1", row, userClaims);
        log:printInfo("Successfully updated spreadsheet!");
}
