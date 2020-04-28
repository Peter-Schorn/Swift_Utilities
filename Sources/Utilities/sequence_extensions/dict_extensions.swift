//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/28/20.
//

import Foundation


public extension Dictionary {
    
    func valuesArray() -> [Dictionary.Value] {
        return self.values.map { $0 }
    }
    func keysArray() -> [Dictionary.Key] {
        return self.keys.map { $0 }
    }
    
}


