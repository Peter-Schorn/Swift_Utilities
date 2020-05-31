import Foundation


public extension Collection where Element: Hashable  {
    
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

public extension Collection where Element: Equatable {
    
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
