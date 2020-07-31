import Foundation
import XCTest
import Utilities


class MathTests: XCTestCase {

    static var allTests = [
        ("testOperators", testOperators),
        ("testNumbersAreClose", testNumbersAreClose),
        ("testFactorial", testFactorial)
    ]
    
    func testOperators() {

        XCTAssert(1 ≤ 2)
        XCTAssert(1 ≤ 1)
        XCTAssert(2 ≥ 1)
        XCTAssert(2 ≥ 2)
        
        XCTAssertEqual(5 ** 2, Int(25))  // Ints
        XCTAssertEqual(5.0 ** 2.0, Double(25.0))  // Doubles
        
        var x = 10
        x **= 2
        XCTAssertEqual(x, Int(100))
        
        var y = 4.0
        y **= 2
        XCTAssertEqual(y, Double(16))
        
        
    }

    func testNumbersAreClose() {
        
        XCTAssert((1.1 + 2.2).isAlmostEqual(to: 3.3))
        XCTAssert((1.1 + 0.3).isAlmostEqual(to: 1.4))
        XCTAssert((0.1 + 0.2).isAlmostEqual(to: 0.3))
        XCTAssert(10.isAlmostEqual(to: 9, relativeTolerance: 0.9))
        XCTAssert(Double.infinity.isAlmostEqual(to: .infinity))
        XCTAssertFalse(Double.nan.isAlmostEqual(to: .nan))
        
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
