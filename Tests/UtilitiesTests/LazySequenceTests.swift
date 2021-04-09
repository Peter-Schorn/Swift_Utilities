//
//  File.swift
//  
//
//  Created by Peter Schorn on 6/15/20.
//

import Foundation
import XCTest
import Utilities
import XCTestCaseExtensions

class LazySequenceExtensions: BaseTestCase {
    
    static var allTests = [
        ("testSplitAndLines", testSplitAndLines)
    ]
    
    func testSplitAndLines() {
        
        let commaSeparated = "one,two,three"
        let multiLineText = """
        one
        two
        three
        """

        var commaSeparatedResults: [String] = []
        for item in commaSeparated.lazy.split(separatedBy: ",") {
            commaSeparatedResults.append(item)
        }
        XCTAssertEqual(commaSeparatedResults, ["one", "two", "three"])
        
        var multilineTextResults: [String] = []
        for item in multiLineText.lines() {
            multilineTextResults.append(item)
        }
        XCTAssertEqual(multilineTextResults, ["one", "two", "three"])

    
        
    }
    
    
}
