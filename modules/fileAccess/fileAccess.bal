import ballerina/io;

public function readData (string email) returns json|error? {
    json|io:Error content = io:fileReadJson("/Users/gastro/Documents/Databases/Temporary/"+email+".json");
    return content;
}

public function saveData (json content, string email) returns error? {
    io:Error? result = io:fileWriteJson("/Users/gastro/Documents/Databases/Temporary/"+email+".json", content);
    return result;
}



// public function saveData (map<anydata>[] content) returns error? {
//     io:Error? result = io:fileWriteCsv("/Users/gastro/Documents/Databases/Temporary/test.csv", content, "APPEND");
//     return result;
// }

// public function readData () returns string[][]|error? {
//     string[][]|io:Error data = io:fileReadCsv("/Users/gastro/Documents/Databases/Temporary/sample.csv");
//     return data;
//     //record[]|io:Error content = io:fileReadCsv("./resources/myfile.csv");
// }

// // type Coord record {int x;int y;};
// // Coord[] contentRecord = [{x: 1,y: 2},{x: 1,y: 2}]
// // string[][] content = [["Anne", "Johnson", "SE"], ["John", "Cameron", "QA"]];
// // io:Error? result = io:fileWriteCsv("./resources/myfile.csv", content);
// // io:Error? resultRecord = io:fileWriteCsv("./resources/myfileRecord.csv", contentRecord);