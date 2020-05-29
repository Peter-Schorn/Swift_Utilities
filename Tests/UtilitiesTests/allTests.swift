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
        ("testArrayFilterMap", testArrayFilterMap),
        ("testShellScripting", testShellScripting),
        ("testJSONThings", testJSONThings),
        ("testCollectionDuplicatesAndAppendUnique", testCollectionDuplicatesAndAppendUnique),
        ("testEquatableArrayDuplicates", testEquatableArrayDuplicates),
        ("testAnySequence", testAnySequence),
        ("testSafeIndexing", testSafeIndexing)
    ]

}
