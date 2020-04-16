//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/9/20.
//

import Foundation
import SwiftUI

/// enables passing in negative indices to access characters
/// starting from the end and going backwards
func negative(_ num: Int, _ count: Int) -> Int {
    return num < 0 ? num + count : num
}

/// Adds the ability to throw an error with a custom message
/// Usage: `throw "There was an error"`
extension String: Error { }

public extension String {
    
    /**
     the following three subscripts add the ability to
     access singe characters and slices of strings
     as if they were an array of characters
     Usage: string[n] or string[n...n] or string[n..<n]
     where n is an integer. Supports negative indexing!
     */
    subscript(_ i: Int) -> String {
        let j = negative(i, self.count)
        let idx1 = index(startIndex, offsetBy: j)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }

    subscript (r: Range<Int>) -> String {
        let lower = negative(r.lowerBound, self.count)
        let upper = negative(r.upperBound, self.count)

        let start = index(startIndex, offsetBy: lower)
        let end = index(startIndex, offsetBy: upper)
        return String(self[start ..< end])
    }

    subscript (r: CountableClosedRange<Int>) -> String {
        let lower = negative(r.lowerBound, self.count)
        let upper = negative(r.upperBound, self.count)
        
        let startIndex =  self.index(self.startIndex, offsetBy: lower)
        let endIndex = self.index(startIndex, offsetBy: upper - lower)
        return String(self[startIndex...endIndex])
    }
    
    /**
     Simplfies regular expressions
     Usage: String.regex(pattern)
     - Parameter regex: regular expression pattern
     - Returns: an array of matches or nil if none were found
     */
    func regex(_ regex: String) -> [[String]]? {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else {
            return nil
        }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        let matches = results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
        return matches == [] ? nil : Optional(matches)
        
    }

    /**
     performs a regular expression replacement
     - Parameters:
       - pattern: regular expression patter
       - with: the string to replace matching patterns with
     - Returns: the new string
     */
    func regexSub(_ pattern: String, with: String = "") -> String {
        return self.replacingOccurrences(
            of: pattern, with: with, options: [.regularExpression]
        )
    }
    
    /// see regexSub
    mutating func regexSubInPlace(
        _ pattern: String, with: String = ""
    ) -> String {
    
        self = self.regexSub(pattern, with: with)
        return self
    }
    
    // enum Side { case left, right }
    
    /// Removes trailing and leading white space.
    /// Alias for self.trimmingCharacters(in: .whitespacesAndNewlines)
    func strip() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Strips trailing and leading white space **in place**
    mutating func stripInPlace() -> String {
        self = self.strip()
        return self
    }

    /// alias for .components(separatedBy: separator)
    func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }
    
}

// MARK: - String interpolations


protocol CustomStringInterpolation {
    mutating func appendInterpolation(_: String)
}

extension CustomStringInterpolation {
    mutating func appendInterpolation(_ value: Double, numFormat: String) {
        appendInterpolation(value.format(numFormat))
    }
    mutating func appendInterpolation(_ value: Double, numFormat: Double.FormatOption) {
        appendInterpolation(value.format(numFormat))
    }
}

extension LocalizedStringKey.StringInterpolation: CustomStringInterpolation {}
extension String.StringInterpolation: CustomStringInterpolation {}
