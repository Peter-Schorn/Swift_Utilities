//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/10/20.
//

import Foundation



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
    
    /// Returns true if the closure returns true for any of the elements
    /// in the sequence. Else false.
    func any(_ closure: (Element) -> Bool ) -> Bool {
        
        for element in self {
            if closure(element) { return true }
        }
        return false
    
    }
    
    /// Returns true if the closure returns true for all of the elements
    /// in the sequence. Else false.
    func all(_ closure: (Element) -> Bool ) -> Bool {
        
        for element in self {
            if !closure(element) { return false }
        }
        return true
    
    }
    
    
    /// Similar to map, except if the closure returns nil,
    /// then the element is not added to the new array.
    /// This is modeled after Python's list comprehension.
    func filterMap(_ closure: (Element) -> Element?) -> [Element] {
        
        var newArray: [Element] = []
        for item in self {
            if let result = closure(item) {
                newArray.append(result)
            }
        }
        return newArray
    }
    
    
}


extension Array where Element == Character {

    /// Join array of characters into String with separator
    func joined(separator: String = "") -> String {
        var string = ""
        for (indx, char) in self.enumerated() {
            if indx > 0 {
                string.append(separator)
            }
            string.append(char)
        }
        return string
    }

}

extension Array where Element == String {
    
    /// Creates an array of single-character Strings,
    /// whereas the default behavior is to create an array of
    /// Characters from a string.
    init(asStrings string: String) {
        self = string.map { String($0) }
    }
}


public extension Array where Element: BinaryInteger {
    
    var average: Double {
        let total = self.reduce(Double(0), { $0 + Double($1) })
        return total / Double(self.count)
    }
    
}

public extension Array where Element: BinaryFloatingPoint {
    
    
    var average: Element {
        let total = self.reduce(0, { $0 + $1 })
        return total / Element(self.count)
    }

}


