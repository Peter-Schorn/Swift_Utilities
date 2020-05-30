import Foundation
import XCTest
import Utilities


extension UtilitiesTests {
    
    func testRegexFindAll() {
        // print("\n\n")
        
        var text = "season 8, episode 5; season 5, episode 20"

        if let results = text.regexFindAll(#"season (\d+), episode (\d+)"#) {
       
            // print(results[0].groups)
            
            XCTAssertEqual(results[0].fullMatch, "season 8, episode 5")
            XCTAssertEqual(results[0].groups, [Optional("8"), Optional("5")])
            
            XCTAssert(type(of: results[0].groups[0]) == Optional<String>.self)
            
            XCTAssertEqual(results[1].fullMatch, "season 5, episode 20")
            XCTAssertEqual(results[1].groups, [Optional("5"), Optional("20")])
            
            text.replaceSubrange(results[0].range, with: "new value")
            XCTAssertEqual(text, "new value; season 5, episode 20")

        }
        else {
            XCTFail("should've found match")
        }
        
        // print("\n\n")
    }
    
    func testRegexMatch() {
        // print("\n\n")
        
        let url = "https://www.sitepoint.com/demystifying-regex-with-practical-examples/"
        let pattern = #"^(http|https|ftp):[\/]{2}([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,4})(:[0-9]+)?\/?([a-zA-Z0-9\-\._\?\,\'\/\\\+&amp;%\$#\=~]*)"#
        
        if let result = url.regexMatch(pattern) {
            XCTAssertEqual(
                result.fullMatch,
                "https://www.sitepoint.com/demystifying-regex-with-practical-examples/"
            )
            // print(result.groups)
            XCTAssertEqual(
                result.groups,
                [
                    Optional("https"),
                    Optional("www.sitepoint.com"),
                    nil,
                    Optional("demystifying-regex-with-practical-examples/")
                ]
            )
            
        }
        else {
            XCTFail("should've found regex match")
        }
        
        
        var text = "season 8, episode 5; season 5, episode 20"

        if let results = text.regexFindAll(#"season (\d+), episode (\d+)"#) {
            // for result in results {
            //     // print("fullMatch: \"\(result.fullMatch)\", groups: \(result.groups)")
            // }

            text.replaceSubrange(results[0].range, with: "new value")
            XCTAssertEqual(text, "new value; season 5, episode 20")
            // print("replaced text:", text)
            
        }
        else {
            XCTFail("should've found match")
        }
        
        
        
        let inputText = "Details {name: Peter, AGE: 21, seX: Male}"

        if let match = inputText.regexMatch(
            #"NAME: (\w+), age: (\d{2}), sex: (male|female)"#, [.caseInsensitive]
        ) {
            XCTAssertEqual(match.fullMatch, "name: Peter, AGE: 21, seX: Male")
            
            XCTAssertEqual(
                match.groups,
                [Optional("Peter"), Optional("21"), Optional("Male")]
            )
            
            let replaced = inputText.replacingCharacters(in: match.range, with: "null")
            XCTAssertEqual(replaced, "Details {null}")
            
        }
        else {
            XCTFail("should've found match")
        }
        
        
        
    }
    
    func testRegexSub() {
        
        let text = "John Doe, age 21"
        let newText = text.regexSub(#"\d+$"#, with: "unknown")
        XCTAssertEqual(newText, "John Doe, age unknown")
        
    }
    
    
    
    
}
