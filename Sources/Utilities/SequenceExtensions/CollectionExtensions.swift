import Foundation

public extension Collection {
    
    /// Retrieves an element from the end of the collection backwards.
    /// self[back: 1] retrieves the last element, self[back: 2] retrieves
    /// the second to last element, and so on.
    ///
    /// - Parameter back: the negative index of an element in the collection.
    subscript(back i: Int) -> Element {
        let indx = self.index(self.endIndex, offsetBy: -i)
        return self[indx]
    }
    
    /// Returns an element of the colletion at the specified index
    /// as an optional. Returns nil if the index is out of bounds.
    /// This can be useful for optional chaining.
    subscript(safe i: Index?) -> Element? {
        guard let i = i else { return nil }
        return self.indices.contains(i) ? self[i] : nil
    }
    
    /// Combines `subscript(back:)` and `subscript(safe:)`
    /// That is, elements are retrieved from the end of the
    /// collection backwards and are returned as optional values.
    subscript(backSafe i: Int?) -> Element? {
        
        guard let i = i else { return nil }
        
        let indx = self.index(self.endIndex, offsetBy: (-i))
        
        if self.indices.contains(indx) {
            return self[back: i]
        }
        
        return nil
    }
    
    
    /// Returns an array of all the elements at the
    /// specified indices.
    subscript(indices indices: [Index]) -> [Element] {
        return indices.map { indx in
            self[indx]
        }
    }
    
    /// Returns an array of all the elements at the
    /// specified indices.
    subscript(indices indices: Index...) -> [Element] {
        return self[indices: indices]
    }
    
    
}


public extension Collection where Element: BinaryInteger {
    
    var average: Double {
        let total = self.reduce(Double(0), { $0 + Double($1) })
        return total / Double(self.count)
    }
    
}

public extension Collection where Element: BinaryFloatingPoint {
    
    
    var average: Element {
        let total = self.reduce(0, { $0 + $1 })
        return total / Element(self.count)
    }

}


public extension Collection where Index == Int {

    /// Splits the collection into an array of arrays,
    /// each of which will have the specified size.
    func chunked(size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, self.count)])
        }
    }

}



public extension MutableCollection {
    
    /**
     Calls the provided closure for each element in self,
     passing in the index of an element and a reference to it
     that can be mutated.
     
     Example usage:
     ```
     var numbers = [0, 1, 2, 3, 4, 5]

     numbers.mutateEach { indx, element in
         if [1, 5].contains(indx) { return }
         element *= 2
     }

     print(numbers)
     // [0, 1, 4, 6, 8, 5]
     ```
     */
    mutating func mutateEach(
        _ modifyElement: (Index, inout Element) throws -> Void
    ) rethrows {
        
        for indx in self.indices {
            try modifyElement(indx, &self[indx])
        }

    }

}
