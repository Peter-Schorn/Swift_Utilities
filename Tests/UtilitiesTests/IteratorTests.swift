import Foundation
import XCTest
import Utilities


class IteratorTests: XCTestCase {

    static var allTests = [
        ("testCIterator", testCIterator),
        ("testExponentiate", testExponentiate)
    ]
    
    
    func testExponentiate() {
     
        var doubledArray: [Double] = []

        for i in exponetiate(start: 3, power: 2, max: 43_046_721, range: .closed) {
            
            doubledArray.append(i)
        }
        
        XCTAssertEqual(doubledArray, [3.0, 9.0, 81.0, 6561.0, 43046721.0])
    
    }
    
    
    func testCIterator() {
        
        let letters = ["a", "b", "c", "d", "e", "f", "g"]
        var sameLetters: [String] = []
        
        for letter in c_iterator(
            init: 0, while: { $0 < letters.count }, update: { $0 + 1 }
        ) {
            sameLetters.append(letters[letter])
            
        }

        XCTAssertEqual(letters, sameLetters)
        
        
        
    }


}
