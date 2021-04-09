import Foundation
import XCTest
import Utilities


class StringTests: BaseTestCase {
    
    static var allTests = [
        ("testStringFormatting", testStringFormatting),
        ("testRemoveFirstChar", testRemoveFirstChar)
    ]
    
    func testStringFormatting() {
        XCTAssert(
            String(format: "$%.2f", 5.4) ==
            5.4.asCurrency(locale: .init(identifier: "en_US"))
        )
        XCTAssert(
            String(format: "$%.2f", 5.4) ==
            5.4.asCurrency(locale: .init(identifier: "en_US"))
        )
        XCTAssert(
            String(format: "$%.2f", 5.4) ==
            5.4.format("$%.2f")
        )
        
    }
    
    func testRemoveFirstChar() {
        
        var name = "Peter"
        
        name.removeFirst { $0 == "e" }
        
        XCTAssertEqual(name, "Pter")
        
    }
    
}
