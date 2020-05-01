import Foundation
import XCTest
import Utilities

let separator =
"------------------------------------------------------------------------"

final class TestBench: XCTestCase {
    
    func testBenchFunction() {
        print(separator + "\n")
        for f in allTestBenchFunctions {
            print()
            f()
            print()
        }
        print("\n" + separator)
    }

    static var allTests = [
        ("testBenchFunction", testBenchFunction)
    ]
}

