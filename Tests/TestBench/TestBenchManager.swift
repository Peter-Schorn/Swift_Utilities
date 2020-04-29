import Foundation
import XCTest
import Utilities

final class TestBench: XCTestCase {
    
    let separator =
    "------------------------------------------------------------------------"
    
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

