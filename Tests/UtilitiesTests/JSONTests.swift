import Foundation
import XCTest
import Utilities


class JSONTests: XCTestCase {

    static var allTests = [
        ("testJSONAndTempDir", testJSONAndTempDir)
    ]
    
    
    func testJSONAndTempDir() {
        
        if #available(macOS 10.15, *) {
        
            assertNoThrow {
                
                try withTempDirectory { tempDir, _ in
                    let jsonPath = tempDir.appendingPathComponent("dictionary.json")
                    
                    let data = ["name": "peter", "age": "21", "sex": "male"]
                    
                    assertNoThrow {
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
            // catch {
            //     XCTFail("\(error)")
            // }
        
        }
        else {
            paddedPrint(
                "WARNING: can't perform test method 'testJSONAndTempDir' on macOS < 10.15",
                padding: "-".multiplied(by: 58) + "\n" + "-".multiplied(by: 58)
            )
        }
        
    }

}
