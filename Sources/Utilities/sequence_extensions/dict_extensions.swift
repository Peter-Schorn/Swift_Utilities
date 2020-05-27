//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/28/20.
//

import Foundation


public extension Dictionary {
    
    func valuesArray() -> [Dictionary.Value] {
        return Array(self.values)
    }
    func keysArray() -> [Dictionary.Key] {
        return Array(self.keys)
    }
    
}


