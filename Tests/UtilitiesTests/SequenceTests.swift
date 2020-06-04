import Foundation
import XCTest
import Utilities


class SequenceTests: XCTestCase {
    
    static var allTests = [
        ("testAnySequence", testAnySequence),
        ("testArraySafeIndexing", testArraySafeIndexing),
        ("testCollectionDuplicatesAndAppendUnique", testCollectionDuplicatesAndAppendUnique),
        ("testEquatableArrayDuplicates", testEquatableArrayDuplicates),
        ("testArrayNegativeIndexing", testArrayNegativeIndexing),
        ("testArrayChunking", testArrayChunking)
    ]
    
    func testCollectionDuplicatesAndAppendUnique() {
        
        var myList = [1, 2, 3, 4, 5, 1]
        XCTAssert(myList.hasDuplicates)
        myList.removeDuplicates()
        XCTAssertFalse(myList.hasDuplicates)
        
        var myList_2 = [1, 2, 3, 4, 5]
        myList_2.appendUnique(contentsOf: [4, 5, 5, 6, 7, 7])
        
        let mySet: Set = [100, 200, 300, 1, 2, 3, 4, 5]
        
        myList_2.appendUnique(contentsOf: mySet)
        XCTAssertFalse(myList_2.hasDuplicates)
        
        // XCTAssertEqual(myList_2, [1, 2, 3, 4, 5, 6, 7, 100, 200, 300])
        // myList_2.elem
        
        
        
    }
    
    func testEquatableArrayDuplicates() {
        
        struct Person: Equatable {
            var name = "Peter"
            var age = 21
        }
        
        var people = Array(repeating: Person(), count: 5)
        people.append(Person(name: "Eric", age: 50))
        
        XCTAssert(people.hasDuplicates)
        
        people.removeDuplicates()
        
        XCTAssertFalse(people.hasDuplicates)
        XCTAssertEqual(people, [Person(), Person(name: "Eric", age: 50)])
        
        
    }
    
    func testAnySequence() {
        
        let items = [1, 2, 3, 4, 5]
        
        XCTAssert(items.any( { $0 == 5 }))
        XCTAssertFalse(items.any( { $0 == 500 }))
        
    }
    
    func testArraySafeIndexing() {
        
        let items = [0, 1, 2, 3, 4]
        
        if let num = items[safe: 2] {
            XCTAssertEqual(num, 2)
        }
        else {
            XCTFail("index should be in bounds")
        }
        
        if let x = items[safe: 5] {
            XCTFail("index should be OUT of bounds (got \(x))")
        }
        
        
    }
    
    func testArrayNegativeIndexing() {
        
        let letters = ["a", "b", "c", "d"]
        XCTAssertEqual(letters[back: 1], "d")
        XCTAssertEqual(letters[back: 2], "c")
        XCTAssertEqual(letters[back: 3], "b")
        XCTAssertEqual(letters[back: 4], "a")
        
        
        var items = ["x", "y", "z"]
        items[back: 1] = "new z"
        items[back: 2] = "new y"
        items[back: 3] = "new x"
        XCTAssertEqual(items, ["new x", "new y", "new z"])
        
        
    }
    
    
    func testSequenceSum() {
        
        let items = [1, 2, 3, 4, 5]
        XCTAssertEqual(items.sum, 15)
        
        let set: Set = [35, 67, 98, 3]
        XCTAssertEqual(set.sum, 203)
        
    }
    
    func testArrayChunking() {
        
        let original = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]

        let chunked = original.chunked(size: 3)

        XCTAssertEqual(
            chunked,
            [
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 9],
                [10, 11, 12],
                [13, 14, 15],
                [16]
            ]
        )
        
        
    }
    
    
    
}
