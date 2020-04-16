//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/10/20.
//

import Foundation

public extension Sequence where Element: Numeric {
    
    /// returns the sum of the elements in a sequence
    var sum: Element { self.reduce(0, +) }

}

public extension Array {
    
    /// Splits array into array of arrays with specified size
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    /// Enables accessing elemnts from the end backwards
    /// [back: 1] returns the last element,
    /// [back: 2] returns the second last, and so on
    subscript(back i: Int) -> Element {
        
        get { return self[self.count - i] }
        set { self[self.count - i] = newValue }
    }
 
    subscript(safe i: Int) -> Element? {
        
        get {
            if 0..<self.count ~= i {
                return Optional(self[i])
            }
            return nil
        }
    }
    
}

public extension Array where Element: BinaryInteger {
    
    var average: Double {
        let total = self.reduce(Double(0), { $0 + Double($1) })
        return total / Double(self.count)
    }
    
}

public extension Array where Element: BinaryFloatingPoint {
    
    var average: Double {
        let total = self.reduce(Double(0), { $0 + Double($1) })
        return total / Double(self.count)
    }

}