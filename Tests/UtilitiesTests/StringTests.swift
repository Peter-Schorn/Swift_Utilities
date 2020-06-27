import Foundation
import XCTest
import Utilities


class StringTests: XCTestCase {
    
    static var allTests = [
        ("testStringFormatting", testStringFormatting),
        ("testGetStringByIndex", testGetStringByIndex),
        ("testSetStringByIndex", testSetStringByIndex),
        ("testExtendedGraphemeClusters", testExtendedGraphemeClusters),
        ("testRemoveFirstChar", testRemoveFirstChar)
    ]
    
    func testStringFormatting() {
        XCTAssert(String(format: "$%.2f", 5.4) == 5.4.format(.currency(.US)))
        XCTAssert(String(format: "$%.2f", 5.4) == 5.4.format("$%.2f"))
    }
    
    func testGetStringByIndex() {
        XCTAssertEqual("012"[0], "0")
        XCTAssertEqual("012"[1], "1")
        XCTAssertEqual("012"[2], "2")
        
        XCTAssertEqual("012"[0...0], "0")
        XCTAssertEqual("012"[0...2], "012")
        XCTAssertEqual("012"[2...2], "2")
        XCTAssertEqual("012"[1...2], "12")
        
        XCTAssertEqual("012"[0..<3], "012")
        XCTAssertEqual("012"[3..<3], "")
        XCTAssertEqual("012"[1..<2], "1")
        
        XCTAssertEqual("012"[-1], "2")
        XCTAssertEqual("012"[-2], "1")
        XCTAssertEqual("012"[-3], "0")
        
        XCTAssertEqual("012"[(-3)...(-1)], "012")
        XCTAssertEqual("012"[(-3)...(-2)], "01")
        XCTAssertEqual("012"[(-2)...(-1)], "12")
        
        XCTAssertEqual("012"[(-2)..<(-1)], "1")
        XCTAssertEqual("012"[(-3)..<(-2)], "0")
        XCTAssertEqual("012"[(-3)..<(-3)], "")
        XCTAssertEqual("012"[(-1)..<(-1)], "")
        XCTAssertEqual("012"[(-3)..<(-1)], "01")
        
        
        
        XCTAssertEqual("0123"[..<2], "01")
        XCTAssertEqual("0123"[...2], "012")
        XCTAssertEqual("0123"[2...], "23")
        
    }
    
    func testSetStringByIndex() {
        var string = "123"
        string[0] = "a"
        string[1] = "b"
        string[2] = "c"
        XCTAssertEqual(string, "abc")
        
        var string2 = "123"
        string2[-3] = "a"
        string2[-2] = "b"
        string2[-1] = "c"
        XCTAssertEqual(string2, "abc")
        
        var string3 = "123"
        string3[0...2] = "abc"
        XCTAssertEqual(string3, "abc")
        
        var string4 = "123"
        string4[0...1] = "ab"
        XCTAssertEqual(string4, "ab3")
        
        var string5 = "123"
        string5[0..<2] = "ab"
        XCTAssertEqual(string5, "ab3")
        
        var string6 = "123"
        string6[0..<1] = "a"
        XCTAssertEqual(string6, "a23")
        
        var string7 = "123"
        string7[(-3)...(-1)] = "abc"
        XCTAssertEqual(string7, "abc")
        
        var string8 = "123"
        string8[(-3)...(-2)] = "ab"
        XCTAssertEqual(string8, "ab3")
        
        var string9 = "123"
        string9[(-3)..<(-2)] = "a"
        XCTAssertEqual(string9, "a23")
        
        var string10 = "123"
        string10[(-2)..<(-2)] = ""
        XCTAssertEqual(string10, "123")
        
        
        var string11 = "0123"
        string11[...2] = "abc"
        XCTAssertEqual(string11, "abc3")
        
        var string12 = "0123"
        string12[2...] = "cd"
        XCTAssertEqual(string12, "01cd")
        
        var string13 = "0123"
        string13[..<2] = "ab"
        XCTAssertEqual(string13, "ab23")
        
        var string14 = "0123"
        string14[..<(-1)] = "abc"
        XCTAssertEqual(string14, "abc3")
        
        var string15 = "0123"
        string15[...(-1)] = "abcd"
        XCTAssertEqual(string15, "abcd")
        
        
        var string16 = "012345"
        string16[(-3)...] = "abc"
        XCTAssertEqual(string16, "012abc")
        
    }
    
    func testExtendedGraphemeClusters() {
                  // "0 1 2 3 4"
        var string = "🦧🔥🎭🚅î"
        XCTAssertEqual(string[0], "🦧")
        XCTAssertEqual(string[1], "🔥")
        XCTAssertEqual(string[2], "🎭")
        XCTAssertEqual(string[3], "🚅")
        XCTAssertEqual(string[4], "î")
        
        string[2] = "a"
        string[-4] = "நி"
        
        XCTAssertEqual(string, "🦧நிa🚅î")
        
        let string2 = "🇺🇸🇸🇾🇧🇱🇱🇰"
        XCTAssertEqual(string2[(-2)...], "🇧🇱🇱🇰")
    }
    
    

    func testRemoveFirstChar() {
        
        var name = "Peter"
        
        name.removeFirst { $0 == "e" }
        
        XCTAssertEqual(name, "Pter")
        
    }
    
}
