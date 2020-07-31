import Foundation




public extension RangeReplaceableCollection {

    /// Retrieves (and sets the value of) an element
    /// from the end of the collection backwards.
    /// self[back: 1] retrieves the last element, self[back: 2] retrieves
    /// the second to last element, and so on.
    ///
    /// - Parameter back: the negative index of an element in the collection.
    subscript(back i: Int) -> Element {
        get {
            let indx = self.index(self.endIndex, offsetBy: (-i))
            return self[indx]
        }

        set {
            let indx = self.index(self.endIndex, offsetBy: (-i))
            self.replaceSubrange(indx...indx, with: [newValue])
        }
    }

}

public extension RangeReplaceableCollection {
    
    /**
     Removes the first element that satisfies the given
     predicate.
     
     This method usually has better
     performance characteristics than `self.removeAll(where:)`
     if only a single element needs to be removed from the
     collection because it returns after the first time that
     the predicate returns true, whereas `self.removeAll(where:)`
     will traverse the entire collection.
     
     - Parameter shouldBeRemoved: A closure that takes an element of
           the collection as its argument and returns a Boolean value
           indicating whether the element should be removed
           from the collection.
     
     - Returns: The element of the collection that was removed
           or nil if an item was not removed.
     */
    @discardableResult
    mutating func removeFirst(
        where shouldBeRemoved: (Element) throws -> Bool
    ) rethrows -> Element? {
        
        for (indx, element) in zip(self.indices, self) {
            if try shouldBeRemoved(element) {
                self.remove(at: indx)
                return element
            }
        }
        return nil
    }

}



public extension RangeReplaceableCollection where Element: Equatable {
    
    /// Only appends the elements of the new array
    /// that are not contained in self.
    ///
    /// Duplicate elements of the new array
    /// will also not be appended. Duplicate elements of the
    /// original array will **NOT** be removed.
    mutating func appendUnique<C: Collection>(
        contentsOf collection: C
    ) where C.Element == Self.Element {
        
        for newItem in collection {
            if !self.contains(newItem) {
                self.append(newItem)
            }
        }
        
    }
    
    /// Appends the element only if it is not already contained in self.
    ///
    /// Returns true if the element was appended, else false.
    @discardableResult
    mutating func appendIfUnique(element: Element) -> Bool {
        
        if self.contains(element) {
            return false
        }
        self.append(element)
        return true
    }
    
    
    
}

public extension RangeReplaceableCollection where Element: Hashable {
    
    /// Removes duplicates and returns true if their were
    /// duplicates in the array. Else, returns false.
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

public extension RangeReplaceableCollection where Element: Equatable {
    
    /// Removes duplicates and returns true if their were
    /// duplicates in the array. Else returns false.
    @discardableResult
    mutating func removeDuplicates() -> Bool {
        
        
        var hadDuplicates = false
        var seen: [Element] = []
        for item in self {
            if seen.contains(item) {
                self.remove(at: self.firstIndex(of: item)!)
                hadDuplicates = true
            }
            seen.append(item)
        }
        
        return hadDuplicates
    }
    
}



public extension Array where Element == String {
    
    /// Creates an array of single-character strings,
    /// whereas the default initializer for a string
    /// creates an array of characters.
    init(asStrings string: String) {
        self = string.map { String($0) }
    }
}





