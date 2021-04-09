import Foundation
import XCTest
import Utilities


class PropertyWrapperTests: BaseTestCase {
    
    static var allTests = [
        ("testPropertyWrapper", testPropertyWrapper),
        ("testPropertyWrapper2", testPropertyWrapper2)
    ]
    
    func testPropertyWrapper() {
        
        struct Person {
            @RegexRemove(#"\s"#) var name: String
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
        
    }
    
    func testPropertyWrapper2() {
        
        struct Animal {
            @RegexRemove(#"\W"#) var name = ""
            var age: Int
            
            init(name: String, age: Int) {
                print("Animal.init")
                print(#line)
                self.name = name
                self.age = age
            }
        }
        
        print(#line)
        var animal = Animal(name: "#$%Annab^&elle)(*&^%$#@!", age: 7)
        
        print(#line)
        XCTAssertEqual(animal.name, "Annabelle")
        
        animal.name = "^%$#?>>:{}ice"
        XCTAssertEqual(animal.name, "ice")
        
        
        
    }
    
    func testPropertyWrapperDocs() {
        
        struct User {

            // matches non-word characters.
            @RegexRemove(#"\W+"#) var username: String

            init(username: String) {
                self.username = username
            }

        }
        
        let user = User(username: "Peter@Schorn")
        XCTAssertEqual(user.username, "PeterSchorn")
        // print(user.username)
        // prints "PeterSchorn"; the "@" is removed because it matches the pattern.

    }
    
}
