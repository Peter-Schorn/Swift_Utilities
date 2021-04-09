import Foundation
import XCTest
import Utilities

class MathTests: BaseTestCase {

    static var allTests = [
        ("testComparisonOperators", testComparisonOperators),
        ("testFactorial", testFactorial)
    ]
    
    func testComparisonOperators() {

        XCTAssert(1 ≤ 2)
        XCTAssert(1 ≤ 1)
        XCTAssert(2 ≥ 1)
        XCTAssert(2 ≥ 2)
        
    }
    
    
    func testFactorial() {
        XCTAssertEqual(factorial(10), 3_628_800)
        XCTAssertEqual(factorial(0), 1)
        XCTAssertEqual(factorial(1), 1)
        XCTAssertEqual(factorial(2), 2)
        XCTAssertEqual(factorial(3), 6)
        XCTAssertEqual(factorial(4), 24)
        XCTAssertEqual(factorial(5), 120)
    }
    
}
