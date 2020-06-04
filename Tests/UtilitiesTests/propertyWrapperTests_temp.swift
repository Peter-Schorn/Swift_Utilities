import Foundation
import XCTest
import Utilities


extension UtilitiesTests {

    func testPropertyWrapper() {
        
        struct Person {
            @InvalidChars(#"\s"#) var name: String
            var age: Int
            
            init(name: String, age: Int) {
                self.age = age
                self.name = name
            }
        }
        
        var person = Person(name: "peter schorn", age: 21)
        XCTAssertEqual(person.name, "peterschorn")
        
        person.name = " lots of spaces "
        XCTAssertEqual(person.name, "lotsofspaces")
        
        
        
        struct Animal {
            @InvalidChars(#"\W"#) var name = ""
            var age: Int
            
            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }
        }
        
        var animal = Animal(name: "#$%Annab^&elle)(*&^%$#@!", age: 7)
        XCTAssertEqual(animal.name, "Annabelle")
        
        animal.name = "^%$#?>>:{}ice"
        XCTAssertEqual(animal.name, "ice")
        
        
        
    }


}
