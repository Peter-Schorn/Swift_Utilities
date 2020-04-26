//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/9/20.
//

import Foundation
import SwiftUI


public func offsetStrRange(
    _ string: String, range: Range<String.Index>, by num: Int
) -> Range<String.Index> {
    
    return string.index(range.lowerBound, offsetBy: num)
           ..<
           string.index(range.upperBound, offsetBy: num)

}

public func offsetStrRange(
    _ string: String, range: ClosedRange<String.Index>, by num: Int
) -> ClosedRange<String.Index> {
    
    return string.index(range.lowerBound, offsetBy: num)
           ...
           string.index(range.upperBound, offsetBy: num)

}


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
        
        let idx1 = self.index(self.startIndex, offsetBy: lower)
        let idx2 = self.index(self.startIndex, offsetBy: upper)
        
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
            self.replaceSubrange(range, with: newValue)
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
            self.replaceSubrange(strOpenRange(r), with: newValue)
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
            self.replaceSubrange(strClosedRange(r), with: newValue)
        }
    }
    
    /// `string[n...]`. See PartialRangeFrom
    subscript(r: PartialRangeFrom<Int>) -> String {
        
        get {
            return String(self[strOpenRange(r.lowerBound..<self.count)])
        }
        set {
            self.replaceSubrange(strOpenRange(r.lowerBound..<self.count), with: newValue)
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
            self.replaceSubrange(
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
            self.replaceSubrange(
                strOpenRange(0..<upper, checkNegative: false), with: newValue
            )
        }
        
        
    }
    
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
