import Foundation
import XCTest
import Utilities


final class UtilitiesTests: XCTestCase {

    static var allTests = [
        ("testOperators", testOperators),
        ("testGetStringByIndex", testGetStringByIndex),
        ("testSetStringByIndex", testSetStringByIndex),
        ("testSpecialCharacterSubscript", testExtendedGraphemeClusters),
        ("testRegexFindAll", testRegexFindAll),
        ("testPythonStringFormat", testPythonStringFormat),
        ("testRegexMatch", testRegexMatch),
        ("testShellScripting", testShellScripting),
        ("testJSONAndTempDir", testJSONAndTempDir),
        ("testCollectionDuplicatesAndAppendUnique", testCollectionDuplicatesAndAppendUnique),
        ("testEquatableArrayDuplicates", testEquatableArrayDuplicates),
        ("testAnySequence", testAnySequence),
        ("testArraySafeIndexing", testArraySafeIndexing),
        ("testCannonicalPath", testCannonicalPath),
        ("testURLLastPathName", testURLLastPathName),
        ("testURLResolveAlias", testURLResolveAlias),
        ("testAppendQueryItemToURL", testAppendQueryItemToURL),
        ("testRegexSub", testRegexSub),
        ("testAllAny", testAllAny),
        ("testNumbersAreClose", testNumbersAreClose),
        ("testFactorial", testFactorial),
        ("testArrayNegativeIndexing", testArrayNegativeIndexing),
        ("testArrayChunking", testArrayChunking),
        ("testPropertyWrapper", testPropertyWrapper),
        ("testExponentiate", testExponentiate),
        ("testCIterator", testCIterator)
        
    ]

}
