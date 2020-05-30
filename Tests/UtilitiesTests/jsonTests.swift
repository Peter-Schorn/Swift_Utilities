import Foundation
import XCTest
import Utilities


extension UtilitiesTests {

    func testJSONAndTempDir() {
        
        do {
            try withTempDirectory { tempDir, _ in
                let jsonPath = tempDir.appendingPathComponent("dictionary.json")
                
                let data = ["name": "peter", "age": "21", "sex": "male"]
                do {
                    try saveJSONToFile(url: jsonPath, data: data)
                    
                    var loadedData = try loadJSONFromFile(url: jsonPath, type: [String: String].self)
                    loadedData["height"] = "67"

                    try saveJSONToFile(url: jsonPath, data: loadedData)
                    
                    let moreData = try loadJSONFromFile(url: jsonPath, type: [String: String].self)
                    XCTAssertEqual(moreData, loadedData)

                } catch {
                    XCTFail("\(error)")
                }
            }
        } catch {
            XCTFail("\(error)")
        }
        
    }
    

}
