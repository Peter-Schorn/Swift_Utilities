//
//  File.swift
//  
//
//  Created by Peter Schorn on 5/25/20.
//

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
