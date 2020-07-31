//
//  File.swift
//  
//
//  Created by Peter Schorn on 7/29/20.
//

import Foundation


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
