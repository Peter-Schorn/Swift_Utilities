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
    
    /**
     Enables passing in negative indices to access characters
     starting from the end and going backwards.
     if num is negative, then it is added to the
     length of the string to retrieve the true index.
     */
    func negativeIndex(_ num: Int) -> Int {
        return num < 0 ? num + self.count : num
    }
    
    func strOpenRange(index i: Int) -> Range<String.Index> {
        let j = negativeIndex(i)
        return strOpenRange(j..<(j + 1), checkNegative: false)
    }
    
    func strOpenRange(
        _ range: Range<Int>, checkNegative: Bool = true
    ) -> Range<String.Index> {

        var lower = range.lowerBound
        var upper = range.upperBound

        if checkNegative {
            lower = negativeIndex(lower)
            upper = negativeIndex(upper)
        }
        
        let idx1 = index(self.startIndex, offsetBy: lower)
        let idx2 = index(self.startIndex, offsetBy: upper)
        
        return idx1..<idx2
    }
    
    func strClosedRange(
        _ range: CountableClosedRange<Int>, checkNegative: Bool = true
    ) -> ClosedRange<String.Index> {
        
        var lower = range.lowerBound
        var upper = range.upperBound

        if checkNegative {
            lower = negativeIndex(lower)
            upper = negativeIndex(upper)
        }
        
        let start = self.index(self.startIndex, offsetBy: lower)
        let end = self.index(start, offsetBy: upper - lower)
        
        return start...end
    }
    
    // MARK: - Subscripts
    
    /**
     Gets and sets a character at a given index.
     Negative indices are added to the length so that
     characters can be accessed from the end backwards.
     
     - Attention: The time complexity of this and the below subscripts is O(n).
     Convert the string to an Array of characters for maximum performance,
     although this will, of course, require more memory.
    
     
     Usage: `string[n]`
     */
    subscript(_ i: Int) -> String {
        get {
            return String(self[strOpenRange(index: i)])
        }
        set {
            let range = strOpenRange(index: i)
            replaceSubrange(range, with: newValue)
        }
    }
    
    
    /**
     Gets and sets characters in a half-open range.
     Supports negative indexing.
     
     Usage: `string[n..<n]`
     */
    subscript(_ r: Range<Int>) -> String {
        get {
            return String(self[strOpenRange(r)])
        }
        set {
            replaceSubrange(strOpenRange(r), with: newValue)
        }
    }

    /**
     Gets and sets characters in a closed range.
     Supports negative indexing
     
     Usage: `string[n...n]`
     */
    subscript(_ r: CountableClosedRange<Int>) -> String {
        get {
            return String(self[strClosedRange(r)])
        }
        set {
            replaceSubrange(strClosedRange(r), with: newValue)
        }
    }
    
    /// `string[n...]`. See PartialRangeFrom
    subscript(r: PartialRangeFrom<Int>) -> String {
        
        get {
            return String(self[strOpenRange(r.lowerBound..<self.count)])
        }
        set {
            replaceSubrange(strOpenRange(r.lowerBound..<self.count), with: newValue)
        }
    }
    
    /// `string[...n]`. See PartialRangeThrough
    subscript(r: PartialRangeThrough<Int>) -> String {
        
        get {
            let upper = negativeIndex(r.upperBound)
            return String(self[strClosedRange(0...upper, checkNegative: false)])
        }
        set {
            let upper = negativeIndex(r.upperBound)
            replaceSubrange(
                strClosedRange(0...upper, checkNegative: false), with: newValue
            )
        }
    }
    
    /// `string[...<n]`. See PartialRangeUpTo
    subscript(r: PartialRangeUpTo<Int>) -> String {
        
        get {
            let upper = negativeIndex(r.upperBound)
            return String(self[strOpenRange(0..<upper, checkNegative: false)])
        }
        set {
            let upper = negativeIndex(r.upperBound)
            replaceSubrange(
                strOpenRange(0..<upper, checkNegative: false), with: newValue
            )
        }
        
        
    }
    
    
    // MARK: - Regex
    
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
       - pattern: regular expression pattern.
       - with:
             the string to replace matching patterns with.
             defaults to an empty string.
     - Returns: the new string
     */
    func regexSub(_ pattern: String, with replacement: String = "") -> String {
        return self.replacingOccurrences(
            of: pattern, with: replacement, options: [.regularExpression]
        )
    }
    
    /// see regexSub
    mutating func regexSubInPlace(
        _ pattern: String, with replacement: String = ""
    ) -> String {
    
        self = self.regexSub(pattern, with: replacement)
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
