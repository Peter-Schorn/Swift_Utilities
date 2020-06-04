import Foundation
import XCTest
import Utilities

typealias Opt = Optional


final class UtilitiesTests: XCTestCase {


    
    static var allTests = [
        
        // MARK: File And URL Tests
        ("testShellScripting", testShellScripting),
        ("testCannonicalPath", testCannonicalPath),
        ("testURLLastPathName", testURLLastPathName),
        ("testURLResolveAlias", testURLResolveAlias),
        ("testAppendQueryItemToURL", testAppendQueryItemToURL),
        
        // MARK: Iterator Tests
        ("testCIterator", testCIterator),
        ("testExponentiate", testExponentiate),
        
        // MARK: JSON Tests
        ("testJSONAndTempDir", testJSONAndTempDir),
        
        // MARK: Math Tests
        ("testOperators", testOperators),
        ("testNumbersAreClose", testNumbersAreClose),
        ("testFactorial", testFactorial),
        
        // MARK: Miscellaneous tests
        ("testAllAny", testAllAny),
        ("testTimeUnits", testTimeUnits),
        
        // MARK: Property Wrapper Tests
        ("testPropertyWrapper", testPropertyWrapper),

        // MARK: Regex Tests
        // ("testRegexFindAll", testRegexFindAll),
        // ("testRegexMatch", testRegexMatch),
        // ("testRegexSub", testRegexSub),
        // ("testRegexSplit", testRegexSplit),
        
        // MARK: Sequence Tests
        ("testAnySequence", testAnySequence),
        ("testArraySafeIndexing", testArraySafeIndexing),
        ("testCollectionDuplicatesAndAppendUnique", testCollectionDuplicatesAndAppendUnique),
        ("testEquatableArrayDuplicates", testEquatableArrayDuplicates),
        ("testArrayNegativeIndexing", testArrayNegativeIndexing),
        ("testArrayChunking", testArrayChunking),
        
        // MARK: String Tests
        ("testPythonStringFormat", testPythonStringFormat),
        ("testGetStringByIndex", testGetStringByIndex),
        ("testSetStringByIndex", testSetStringByIndex),
        ("testSpecialCharacterSubscript", testExtendedGraphemeClusters),
        
    ]
    
    
}
