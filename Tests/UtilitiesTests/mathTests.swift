import Foundation
import XCTest
import Utilities


extension UtilitiesTests {

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
        
        
        XCTAssertEqual(√Double(25.0), Double(5.0))
                
    }

    func testNumbersAreClose() {
        
        do {
            let a = 5
            let b = 10
            XCTAssert(numsAreClose(a, b, abs_tol: 5))
        }
        do {
            let a = 90.0
            let b = 100.0
            XCTAssert(numsAreClose(a, b, rel_tol: 0.1))
        }
        XCTAssert(numsAreClose(3.3, 1.1 + 2.2))
        
        
    }
    
    func testFactorial() {
        XCTAssertEqual(factorial(10), 3_628_800)
    }

}