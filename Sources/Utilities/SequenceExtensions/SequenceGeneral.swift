import Foundation

extension Sequence {
    
    
    /**
     Returns the result of combining the elements of the sequence
     using the given closure. **accumulatingResult is initialized
     to the first element of the sequence.**
     
     - Parameter updateAccumulatingResult: A closure
           that accepts the accumulating result as an inout
           variable and the next element of the sequence.
           It does not return anything; you update the
           `accumulatingResult` **in place**.
     - Throws: If `updateAccumulatingResult` throws.
     - Returns: The final accumulated value after calling
           the closure for each element of the sequence
           or nil if the sequence was empty.
     
     `accumulatingResult` is initialized to the first element
     of the sequence. `updateAccumulatingResult` is then called
     for each successive element with the `accumulatingResult`
     passed in as an `inout` variable and the next element of
     the sequence passed in.
     */
    public func reduce(
        _ updateAccumulatingResult: (
            _ accumulatingResult: inout Element,
            _ nextElement: Element
        ) throws -> Void
    ) rethrows -> Element? {
    
        var iterator = self.makeIterator()
        guard var accumulatingResult = iterator.next() else {
            return nil
        }
        while let nextElement = iterator.next() {
            try updateAccumulatingResult(&accumulatingResult, nextElement)
        }
        return accumulatingResult
    
    }

}




public extension Sequence where Element: Numeric {
    
    /// returns the sum of the elements in a sequence
    var sum: Element { self.reduce(0, +) }

}



public extension Sequence {
    
    /// Returns true if the closure returns true for any of the elements
    /// in the sequence. Else false.
    func any(_ predicate: (Element) throws -> Bool ) rethrows -> Bool {
        
        for element in self {
            if try predicate(element) { return true }
        }
        return false
    
    }

    
}


public extension Sequence where Element: Hashable  {
    
    var hasDuplicates: Bool {
        
        var seen: Set<Element> = []
        
        for item in self {
            if !seen.insert(item).inserted {
                return true
            }
        }
        
        return false
    }
    
}

public extension Sequence where Element: Equatable {
    
    var hasDuplicates: Bool {
        
        var seen: [Element] = []
        
        for item in self {
            if seen.contains(item) {
                return true
            }
            seen.append(item)
        }
        
        return false
    }
    
}


public extension Sequence where Element == Character {

    /// Join sequence of characters into String with separator
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
