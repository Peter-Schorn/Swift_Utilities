import Foundation
import XCTest
import Utilities


class MiscellaneousTests: XCTestCase {

    static var allTests = [
        ("testAllAny", testAllAny),
        ("testTimeUnits", testTimeUnits),
    ]
    
    func testTimeUnits() {
        XCTAssertEqual(timeUnit(.hour(1), .minute(2), .second(5)), 3725.0)
    }
   
    
    func testAllAny() {
        
        let result = all(1 == 1, 2 == 2, 3 == 3)
        XCTAssert(result)
        
        let result_2 = any(5 + 5 == 10, 2 + 2 == 5)
        XCTAssert(result_2)
        
    }

}


