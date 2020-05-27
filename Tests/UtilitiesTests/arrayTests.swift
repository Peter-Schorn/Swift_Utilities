import Foundation
import XCTest
import Utilities

extension UtilitiesTests {
    
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
    
    func testCollectionDuplicatesAndAppendUnique() {
        
        var myList = [1, 2, 3, 4, 5, 1]
        XCTAssert(myList.hasDuplicates)
        myList.removeDuplicates()
        XCTAssert(!myList.hasDuplicates)
        
        var myList_2 = [1, 2, 3, 4, 5]
        myList_2.appendUnique(contentsOf: [4, 5, 5, 6, 7, 7])
        XCTAssert(!myList_2.hasDuplicates)
        
        
    }
    
    func testEquatableArrayDuplicates() {
        
        print("\ntestEquatableArrayDuplicates\n")
        
        struct Person: Equatable {
            var name = "Peter"
            var age = 21
        }
        
        var people = Array(repeating: Person(), count: 5)
        people.append(Person(name: "Eric", age: 50))
        
        XCTAssert(people.hasDuplicates)
        
        people.removeDuplicates()
        
        XCTAssert(!people.hasDuplicates)
        XCTAssert(people == [Person(), Person(name: "Eric", age: 50)])
        
        
    }
    
    func testAnySequence() {
        
        let items = [1, 2, 3, 4, 5]
        
        XCTAssert(items.any( { $0 == 5 }))
        XCTAssert(!items.any( { $0 == 500 }))
        
    }
    
    
    
}
