import Foundation


public extension Dictionary {
    
    /// Returns an array of the dictionary's values.
    func valuesArray() -> [Dictionary.Value] {
        return Array(self.values)
    }
    /// Returns an array of the dictionary's keys.
    func keysArray() -> [Dictionary.Key] {
        return Array(self.keys)
    }
    
}


