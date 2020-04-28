//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/24/20.
//

import Foundation


public extension Sequence where Element: Numeric {
    
    /// returns the sum of the elements in a sequence
    var sum: Element { self.reduce(0, +) }

}

