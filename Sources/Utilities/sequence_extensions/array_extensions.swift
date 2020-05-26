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
            if (0..<self.count).contains(i) {
                return self[i]
            }
            return nil
        }

    }
    
    
}


extension Array where Element: Hashable {
    
    /// Removes duplicates and returns true if their were
    /// duplicates in the array. Else returns false
    @discardableResult
    mutating func removeDuplicates() -> Bool {
        
        var hadDuplicates = false
        var seen: Set<Element> = []
        for item in self {
            if !seen.insert(item).inserted {
                hadDuplicates = true
                self.remove(at: self.firstIndex(of: item)!)
            }
        }
        return hadDuplicates
    }
    
}


public extension Array where Element == Character {

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

public extension Array where Element == String {
    
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


