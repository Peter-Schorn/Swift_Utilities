
import Foundation
import SwiftUI


public func UtilitiesTest() {
    print("hello from the Utilities package!")
}


/// Does nothing
public func pass() { }


/// Accepts a sequence as input and forwards it to the print function
/// as a variadic parameter.
public func unpackPrint(
    _ items: [Any], separator: String = " ", terminator: String = "\n"
) {
    unsafeBitCast(
        print, to: (([Any], String, String) -> Void).self
    )(items, separator, terminator)
}


/**
 See Hasher
 
 Body of function:
 ```
 var hasher = Hasher()
 for i in object {
     hasher.combine(i)
 }
 return hasher.finalize()
 ```
 */
func makeHash<H: Hashable>(_ object: H...) -> Int {
    
    var hasher = Hasher()
    for i in object {
        hasher.combine(i)
    }
    return hasher.finalize()
    
}




/// Returns true if any of the arguments are true.
public func any(_ expressions: [Bool]) -> Bool {
    for i in expressions {
        if i { return true }
    }
    return false
}

/// Returns true if any of the arguments are true.
public func any(_ expressions: Bool...) -> Bool {
    return any(expressions)
}


/// Returns true if all of the arguments are true.
public func all(_ expressions: [Bool]) -> Bool {
    for i in expressions {
        if !i { return false }
    }
    return true
}

/// Returns true if all of the arguments are true
public func all(_ expressions: Bool...) -> Bool {
    return all(expressions)
}
