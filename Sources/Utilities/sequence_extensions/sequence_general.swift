import Foundation


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
    
    /**
     Similar to map, except if the closure returns nil,
     then the element is not added to the new array.
     This is modeled after Python's list comprehension.
     
     Usage:
     ```
     let items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

     let newItems: [String] = items.filterMap { item in
         if item < 5 {
             return String(item * 2)
         }
         return nil
     }
     
     // newitems = ["2", "4", "6", "8"]
     ```
     In this example, if the item is less than five, then it is multiplied
     by two, converted to a string, and then added to the array.
     If the item is not less than five, then the closure returns nil,
     which indicates that the item should not be added to the new array.
     The new array does not have to be the same type as the original array,
     as shown above, and just like the map method.
     */
    func filterMap<T>(_ closure: (Element) throws -> T?) rethrows -> [T] {
        
        var newArray: [T] = []
        for item in self {
            if let result = try closure(item) {
                newArray.append(result)
            }
        }
        return newArray
    }
    
}






