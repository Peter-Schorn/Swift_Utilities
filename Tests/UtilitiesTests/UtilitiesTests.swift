import XCTest
import Foundation

@testable import Utilities

final class UtilitiesTests: XCTestCase {

    func testOperators() {
        XCTAssert(1 ≤ 2)
        XCTAssert(1 ≤ 1)
        XCTAssert(2 ≥ 1)
        XCTAssert(2 ≥ 2)
        
        XCTAssert(5 ** 2 == 25) // Ints
        XCTAssert(5.0 ** 2.0 == 25.0) // Doubles
        
    }

    func testStringFormatting() {
        XCTAssert(String(format: "$%.2f", 5.4) == 5.4.format(.currency))
        XCTAssert(String(format: "$%.2f", 5.4) == 5.4.format("$%.2f"))
    }
    
    func testGetStringByIndex() {
        XCTAssert("123"[0] == "1")
        XCTAssert("123"[1] == "2")
        XCTAssert("123"[2] == "3")
        
        XCTAssert("123"[0...0] == "1")
        XCTAssert("123"[0...2] == "123")
        XCTAssert("123"[2...2] == "3")
        XCTAssert("123"[1...2] == "23")
        
        XCTAssert("123"[0..<3] == "123")
        XCTAssert("123"[3..<3] == "")
        XCTAssert("123"[1..<2] == "2")
        
        XCTAssert("123"[-1] == "3")
        XCTAssert("123"[-2] == "2")
        XCTAssert("123"[-3] == "1")
        
        XCTAssert("123"[(-3)...(-1)] == "123")
        XCTAssert("123"[(-3)...(-2)] == "12")
        XCTAssert("123"[(-2)...(-1)] == "23")
        
        XCTAssert("123"[(-2)..<(-1)] == "2")
        XCTAssert("123"[(-3)..<(-2)] == "1")
        XCTAssert("123"[(-3)..<(-3)] == "")
        XCTAssert("123"[(-1)..<(-1)] == "")
        XCTAssert("123"[(-3)..<(-1)] == "12")
        
    }
    
    func testSetStringByIndex() {
        var string = "123"
        string[0] = "a"
        string[1] = "b"
        string[2] = "c"
        XCTAssert(string == "abc")
        
        var string2 = "123"
        string2[-3] = "a"
        string2[-2] = "b"
        string2[-1] = "c"
        XCTAssert(string2 == "abc")
        
        var string3 = "123"
        string3[0...2] = "abc"
        XCTAssert(string3 == "abc")
        
        var string4 = "123"
        string4[0...1] = "ab"
        XCTAssert(string4 == "ab3")
        
        var string5 = "123"
        string5[0..<2] = "ab"
        XCTAssert(string5 == "ab3")
        
        var string6 = "123"
        string6[0..<1] = "a"
        XCTAssert(string6 == "a23")
        
        var string7 = "123"
        string7[(-3)...(-1)] = "abc"
        XCTAssert(string7 == "abc")
        
        var string8 = "123"
        string8[(-3)...(-2)] = "ab"
        XCTAssert(string8 == "ab3")
        
        var string9 = "123"
        string9[(-3)..<(-2)] = "a"
        XCTAssert(string9 == "a23")
        
        var string10 = "123"
        string10[(-2)..<(-2)] = ""
        XCTAssert(string10 == "123")
        
    }
    
    
    static var allTests = [
        ("testOperators", testOperators),
        ("testGetStringByIndex", testGetStringByIndex),
        ("testSetStringByIndex", testSetStringByIndex),
    ]
}



