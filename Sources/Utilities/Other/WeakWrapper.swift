//
//  File.swift
//  
//
//  Created by Peter Schorn on 7/29/20.
//

import Foundation


/// Wraps an object in a weak reference.
/// This is useful for creating an array of weak references.
public class WeakWrapper<T: AnyObject> {
    
    public weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
    
    
}
