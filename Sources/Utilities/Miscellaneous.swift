
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


/// Wraps an object in a weak reference.
/// This is useful for creating an array of weak references.
public class WeakWrapper<T: AnyObject>: Hashable {
    
    /// - Warning: This function compares whether two references point to the
    ///       same object. It **DOES NOT** compare whether the wrapped objects are
    ///       the same because they are not required to conform to `Equatable`.
    public static func == <T>(lhs: WeakWrapper<T>, rhs: WeakWrapper<T>) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public weak var object: T?
    public let id = UUID()
    
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


/// Returns true if all expressions evaluate to the same value.
/// Else false.
public func allEqual<E: Equatable>(_ expressions: E...) -> Bool {
    return allEqual(expressions)
}

/// Returns true if all expressions evaluate to the same value.
/// Else false.
public func allEqual<E: Equatable>(_ expressions: [E]) -> Bool {
    if expressions.count == 0 { return true }
    for expression in expressions {
        if !(expression == expressions[0]) { return false }
    }
    return true
}
