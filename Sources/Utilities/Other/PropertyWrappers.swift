import Foundation
import RegularExpressions

/**
 A property wrapper that removes characters
 that match a regular expression pattern.
 
 Everytime the property is mutated, any characters that match the
 provided regular expression pattern are removed.
 
 - Warning: You must provide an explicit initializer for a struct
       that uses this property wrapper. The default member-wise
       initializer will bypass the property wrapper.

 
 ```
 struct User {

     // matches non-word characters.
     @RegexRemove(#"\W+"#) var username: String

     init(username: String) {
         self.username = username
     }

 }
 
 var user = User(username: "Peter@Schorn")
 print(user.username)
 // prints "PeterSchorn"
 // the "@" is removed because it matches the pattern.
 ```
 */
@propertyWrapper
public struct RegexRemove {
    
    private var value = ""
    public let regexObject: Regex
    
    public init(_ regexObject: Regex) {
        self.regexObject = regexObject
        self.value = self.wrappedValue
    }
    
    public init(
        wrappedValue: String,
        _ regexObject: Regex
    ) {
        self.regexObject = regexObject
        self.value = wrappedValue
        self.value = self.wrappedValue
    }
    
    public init(
        _ pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = []
    ) {
        self.regexObject = try! Regex(
            pattern: pattern,
            regexOptions: regexOptions,
            matchingOptions: matchingOptions
        )
        self.value = self.wrappedValue
    }
    
    public init(
        wrappedValue: String,
        _ pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = []
    ) {
        self.regexObject = try! Regex(
            pattern: pattern,
            regexOptions: regexOptions,
            matchingOptions: matchingOptions
        )
        self.value = wrappedValue
        self.value = self.wrappedValue
    }
    
    public var wrappedValue: String {
        get {
            // print("returning wrapped value: '\(try! value.regexSub(regexObject))'")
            return try! value.regexSub(regexObject)
        }
        set {
            // print("setting wrapped value to '\(newValue)'")
            value = newValue
        }
    }

}
