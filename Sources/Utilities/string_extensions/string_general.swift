//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/9/20.
//

import Foundation
import SwiftUI



/// Adds the ability to throw an error with a custom message
/// Usage: `throw "There was an error"`
extension String: Error { }

public extension String {
    
    
    enum StripOptions {
        case fileExt
    }
    
    func strip(_ stripOptions: StripOptions) -> String {
        switch stripOptions {
            case .fileExt:
                return self.regexSub(#"\.([^\.]*)$"#)
        }
    }
    
    /**
     ```
     func strip(_ characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
         return self.trimmingCharacters(in: characterSet)
     }
     ```
     */
    func strip(_ characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return self.trimmingCharacters(in: characterSet)
    }

    /// see String.strip
    mutating func stripInPlace(_ characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        self = self.strip(characterSet)
        return self
    }

    /// see String.strip
    mutating func stripInPlace(_ stripOptions: StripOptions) -> String {
        self = self.strip(stripOptions)
        return self
    }
    
    
    /// alias for .components(separatedBy: separator)
    func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }
    
}

// MARK: - String interpolations

public protocol CustomStringInterpolation {
    mutating func appendInterpolation(_: String)
}

public extension CustomStringInterpolation {
    mutating func appendInterpolation(_ value: Double, numFormat: String) {
        appendInterpolation(value.format(numFormat))
    }
    mutating func appendInterpolation(_ value: Double, numFormat: Double.FormatOption) {
        appendInterpolation(value.format(numFormat))
    }
}

extension LocalizedStringKey.StringInterpolation: CustomStringInterpolation { }
extension String.StringInterpolation: CustomStringInterpolation { }
