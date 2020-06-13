
import Foundation


public func UtilitiesTest() {
    print("hello from the Utilities package!")
}


/// Does nothing
public func pass() { }


/// Accepts an array as input and forwards it to the print function
/// as a variadic parameter. Also accepts a separator and terminator,
/// with the same behavior as the print function.
public func unpackPrint(
    _ items: [Any], separator: String = " ", terminator: String = "\n"
) {
    unsafeBitCast(
        print, to: (([Any], String, String) -> Void).self
    )(items, separator, terminator)
}

/// Prints items with the specififed padding before and after
public func paddedPrint(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    padding: String = "\n\n"
) {

    print(padding)
    unpackPrint(items, separator: separator, terminator: terminator)
    print(padding)

}


/// Wraps a variabe in a weak reference.
/// This is useful for creating an array of weak references.
public class WeakWrapper<T: AnyObject> {
    
    weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
    
}


/**
 See Hasher
 
 Body:
 ```
 var hasher = Hasher()
 for object in objects {
     hasher.combine(object)
 }
 return hasher.finalize()
 ```
 */
public func makeHash<H: Hashable>(_ objects: H...) -> Int {
    return makeHash(objects)
}

/**
See Hasher.

Body:
```
var hasher = Hasher()
for object in objects {
    hasher.combine(object)
}
return hasher.finalize()
```
*/
public func makeHash<H: Hashable>(_ objects: [H]) -> Int {
    
    var hasher = Hasher()
    for object in objects {
        hasher.combine(object)
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
