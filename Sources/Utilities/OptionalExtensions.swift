import Foundation


/**
 Type-erases the wrapped value for Optional.
 This protocol allows for extending other protocols
 contingent on one or more of their associated types
 being any optional type.
 
 For example, this extension to Array adds an instance method
 that returns a new array in which each of the elements
 are either unwrapped or removed if nil. You must use self.value
 for swift to recognize that the generic type is an Optional.
 ```
 extension Array where Element: AnyOptional {

     func removeIfNil() -> [Self.Element.Wrapped] {
         return self.compactMap { $0.optional }
     }

 }
 ```
 Body of protocol:
 ```
 associatedtype Wrapped
 var value: Wrapped? { get set }
 ```
 */
public protocol AnyOptional {

    associatedtype Wrapped
    var optional: Wrapped? { get set }
}

extension Optional: AnyOptional {

    /// Gets and sets self. **Does not unwrap the value**.
    /// This computed property must be used
    /// for swift to recognize the generic type
    /// conforming to `AnyOptional` as an Optional.
    @inlinable
    public var optional: Wrapped? {
        get { return self }
        set { self = newValue }
    }

}

public extension Sequence where Element: AnyOptional {

    /// Returns a new array in which each element in the Sequence
    /// is either unwrapped and added to the new array,
    /// or not added to the new array if nil.
    /// Equivalent
    func removeIfNil() -> [Element.Wrapped] {
        return self.compactMap { $0.optional }
    }
    
}

