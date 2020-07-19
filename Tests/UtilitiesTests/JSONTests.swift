import Foundation
import XCTest
import Utilities
import XCTestCaseExtensions


class JSONTests: XCTestCase {
    
    static var allTests = [
        ("testJSONAndTempDir", testJSONAndTempDir)
    ]
    
    
    func testJSONAndTempDir() throws {
        
        if #available(macOS 10.15, iOS 10.0, *) {
            
            try withTempDirectory { tempDir in
                assertNoThrow {
                    let jsonPath = tempDir.appendingPathComponent("dictionary.json")
                    
                    let data = ["name": "peter", "age": "21", "sex": "male"]
                    
                    try saveJSONToFile(url: jsonPath, data: data)
                    
                    var loadedData = try loadJSONFromFile(
                        url: jsonPath, type: [String: String].self
                    )
                    loadedData["height"] = "67"
                    
                    try saveJSONToFile(url: jsonPath, data: loadedData)
                    
                    let moreData = try loadJSONFromFile(
                        url: jsonPath, type: [String: String].self
                    )
                    XCTAssertEqual(moreData, loadedData)
                }
            }
            
        }
        else {
            paddedPrint(
                "WARNING: can't perform test method 'testJSONAndTempDir' on macOS < 10.15",
                padding: "-".multiplied(by: 58) + "\n" + "-".multiplied(by: 58)
            )
        }
        
    }
    
}
