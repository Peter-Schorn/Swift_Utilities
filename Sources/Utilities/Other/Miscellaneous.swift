
import Foundation


public func utilitiesTest() {
    print("hello from the Utilities package!")
}

/// Accepts an array as the first parameter
/// and forwards it to the print function
/// as a variadic parameter. Also accepts a separator and a terminator,
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


/// Returns true if any of the arguments are true.
public func any(_ expressions: [Bool]) -> Bool {
    for i in expressions {
        if i { return true }
    }
    return false
}

/// Returns true if any of the expressions are true, else false.
public func any(_ expressions: Bool...) -> Bool {
    return any(expressions)
}


/// Returns true if all of the elements in the sequence are true,
/// else false.
public func all<S: Sequence>(
    _ expressions: S
) -> Bool where S.Element == Bool {
    
    for element in expressions {
        if !element { return false }
    }
    return true
}

/// Returns true if all of the arguments are true.
public func all(_ expressions: Bool...) -> Bool {
    return all(expressions)
}


/// Returns true if all expressions evaluate to the same value,
/// else false.
public func allEqual<E: Equatable>(_ expressions: E...) -> Bool {
    var iterator = expressions.makeIterator()
    guard let first = iterator.next() else {
        return true
    }
    while let nextElement = iterator.next() {
        if !(nextElement == first) { return false }
    }
    return true
}


public struct GenericError: LocalizedError, CustomCodable {
    
    public var errorDescription: String?
    
}
