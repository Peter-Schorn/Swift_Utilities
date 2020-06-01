import Foundation



public extension Array {


    /// Enables accessing elemnts from the end backwards
    /// [back: 1] returns the last element,
    /// [back: 2] returns the second last, and so on
    subscript(back i: Int) -> Element {

        get { return self[self.count - i] }
        set { self[self.count - i] = newValue }
    }

    subscript(safe i: Int) -> Element? {
        get {
            return self.indices.contains(i) ? self[i] : nil
        }
    }

}


public extension RangeReplaceableCollection where Index == Int {
 
    subscript(back i: Int) -> Element {
        get {
            print("RangeReplaceableCollection back get")
            return self[self.count - i]
        }

        set {
            print("RangeReplaceableCollection back set")
            let range = (self.count - i)...(self.count - i)
            self.replaceSubrange(range, with: [newValue])
        }
    }
    
}

extension Collection where Index == Int {
    subscript(back i: Int) -> Element {
        return self[self.count - i]
    }
}



public extension RangeReplaceableCollection where Element: Equatable {
    
    /// Only appends the elements of the new array
    /// that are not contained in self. Duplicate elements
    /// of the new array will also not be appended. Duplicate
    /// elements of the original array will **NOT** be removed.
    
    mutating func appendUnique<C: Collection>(
        contentsOf collection: C
    ) where C.Element == Self.Element {
        
        for newItem in collection {
            if !self.contains(newItem) {
                self.append(newItem)
            }
        }
        
    }
    
}

public extension RangeReplaceableCollection where Element: Hashable {
    
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
    
    /// Creates an array of single-character Strings,
    /// whereas the default initializer for a string
    /// creates an array of characters.
    init(asStrings string: String) {
        self = string.map { String($0) }
    }
}





