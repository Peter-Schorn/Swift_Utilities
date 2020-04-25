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
        
        
        
        XCTAssert("0123"[..<2] == "01")
        XCTAssert("0123"[...2] == "012")
        XCTAssert("0123"[2...] == "23")
        
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
        
        
        var string11 = "0123"
        string11[...2] = "abc"
        XCTAssert(string11 == "abc3")
        
        var string12 = "0123"
        string12[2...] = "cd"
        XCTAssert(string12 == "01cd")
        
        var string13 = "0123"
        string13[..<2] = "ab"
        XCTAssert(string13 == "ab23")
        
        var string14 = "0123"
        string14[..<(-1)] = "abc"
        XCTAssert(string14 == "abc3")
        
        var string15 = "0123"
        string15[...(-1)] = "abcd"
        XCTAssert(string15 == "abcd")
        
        
        var string16 = "012345"
        string16[(-3)...] = "abc"
        XCTAssert(string16 == "012abc")
        
    }
    
    func testExtendedGraphemeClusters() {
                  // "0 1 2 3 4"
        var string = "🦧🔥🎭🚅î"
        XCTAssert(string[0] == "🦧")
        XCTAssert(string[1] == "🔥")
        XCTAssert(string[2] == "🎭")
        XCTAssert(string[3] == "🚅")
        XCTAssert(string[4] == "î")
        
        string[2] = "a"
        string[-4] = "நி"
        
        XCTAssert(string == "🦧நிa🚅î")
        
        let string2 = "🇺🇸🇸🇾🇧🇱🇱🇰"
        XCTAssert(string2[(-2)...] == "🇧🇱🇱🇰")
    }
    
    
    func testRegexFindAll() {
        print("\n\n")
        
        var text = "season 8, episode 5; season 5, episode 20"

        if let results = text.regexFindAll(#"season (\d+), episode (\d+)"#) {
       
            print(results[0].groups)
            
            XCTAssert(results[0].fullMatch == "season 8, episode 5")
            XCTAssert(results[0].groups == [Optional("8"), Optional("5")])
            
            XCTAssert(type(of: results[0].groups[0]) == Optional<String>.self)
            
            XCTAssert(results[1].fullMatch == "season 5, episode 20")
            XCTAssert(results[1].groups == [Optional("5"), Optional("20")])
            
            text.replaceSubrange(results[0].range, with: "new value")
            print("replaced text:", text)

        }
        else {
            XCTFail("should've found match")
        }
        
        print("\n\n")
    }
    
    func testRegexMatch() {
        print("\n\n")
        
        let url = "https://www.sitepoint.com/demystifying-regex-with-practical-examples/"
        let pattern = #"^(http|https|ftp):[\/]{2}([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,4})(:[0-9]+)?\/?([a-zA-Z0-9\-\._\?\,\'\/\\\+&amp;%\$#\=~]*)"#
        
        if let result = url.regexMatch(pattern) {
            XCTAssert(result.fullMatch == "https://www.sitepoint.com/demystifying-regex-with-practical-examples/")
            print(result.groups)
            XCTAssert(result.groups == [Optional("https"), Optional("www.sitepoint.com"), nil, Optional("demystifying-regex-with-practical-examples/")])
        }
        else {
            XCTFail("should've found regex match")
        }
        
        
        var text = "season 8, episode 5; season 5, episode 20"

        if let results = text.regexFindAll(#"season (\d+), episode (\d+)"#) {
            for result in results {
                print("fullMatch: \"\(result.fullMatch)\", groups: \(result.groups)")
            }

            text.replaceSubrange(results[0].range, with: "new value")
            print("replaced text:", text)
            
        }
        else {
            print("no matches")
        }
        
        
        print("\n\n")
    }
    
    
    func testPythonStringFormat() {
        
        let name = "Peter Schorn"
        let age  = 21
        let gender = "Male"
        let country = "The United States of America"
        
        let text_1 = "my name is '{{}}', age: '{3}', gender: '{2}' country: '{1}'"
        
        let formmated_1 = text_1.format(name, age, gender, country)
        
        XCTAssert(formmated_1 ==
            "my name is '{}', age: 'The United States of America', gender: 'Male' country: '21'"
        )
        
        let text_2 = "my name is '{{}}', age: '{}', country: '{{}}' gender: '{}'"
            .format(age, gender, country)
        
        print(text_2)
        XCTAssert(text_2 == "my name is '{}', age: '21', country: '{}' gender: 'Male'")
        
        
        let text_3 = "name: {first}, age: {old}, {{abc}}".format(dict: ["first": name, "old": age])
        XCTAssert(text_3 == "name: Peter Schorn, age: 21, {abc}")
        
        
    }
    
    
    func testArrayFilterMap() {
        
        let items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

        let newItems_1: [String] = items.filterMap { item in
            if item < 5 {
                return String(item * 2)
            }
            return nil
        }
        
        XCTAssert(newItems_1 == ["2", "4", "6", "8"])
        
        let newItems_2 = items.filterMap { $0 < 5 ? String($0 * 2) : nil }
        XCTAssert(newItems_2 == ["2", "4", "6", "8"])
        // XCTAssert(newItems_2 == [2, 4, 6, 8])
    }
    
    
    static var allTests = [
        ("testOperators", testOperators),
        ("testGetStringByIndex", testGetStringByIndex),
        ("testSetStringByIndex", testSetStringByIndex),
        ("testSpecialCharacterSubscript", testExtendedGraphemeClusters),
        ("testRegexFindAll", testRegexFindAll),
        ("testPythonStringFormat", testPythonStringFormat),
        ("testRegexMatch", testRegexMatch),
        ("testArrayFilterMap", testArrayFilterMap)
    ]
}



