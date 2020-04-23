//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/23/20.
//

import Foundation

public extension String {
    

    
    
    /**
     Finds all matches for a regular expression pattern in a string.
     
     - Parameters:
        - pattern: Regular expression pattern.
        - options: Regular expression options, such as .caseInsensitive
     - Returns: An array of tuples containing the match and
       the range of the match, Or nil if no matches are found
     
     Usage:
     ```
     let text = "one, two, three"
     if let results = text.regexFindAll(#"\w+"#, [.caseInsensitive]) {
         for result in results {
             print(result.match)
         }
     }
     ```
     */
    func regexFindAll(
        _ pattern: String,
        _ options: NSRegularExpression.Options = []
    ) -> [(match: String, range: Range<String.Index>)]? {
        
        
        guard let regex = try? NSRegularExpression(
            pattern: pattern, options: options
        ) else {
            fatalError("invalid regex")
        }
        
        let results = regex.matches(
            in: self, range: NSMakeRange(0, self.count)
        )
        
        if results == [] { return nil }
        
        return results.map { result in
            let strRange = self.strOpenRange(Range(result.range)!, checkNegative: false)
            return (match: String(self[strRange]), range: strRange)
        }
        
    }
    
    
    /**
     Performs a regular expression replacement
     
     - Parameters:
       - pattern: Regular expression pattern.
       - with: The string to replace matching patterns with.
         defaults to an empty string.
       - options: The options for the regular expression
     - Returns: The new string
     */
    func regexSub(
        _ pattern: String,
        with replacement: String = "",
        _ options: NSString.CompareOptions = []
    ) -> String {
    
        var fullOptions = options
        fullOptions.insert(.regularExpression)
        
        return self.replacingOccurrences(
            of: pattern, with: replacement, options: fullOptions
        )
    }
    
    /// see regexSub
    mutating func regexSubInPlace(
        _ pattern: String,
        with replacement: String = "",
        _ options: NSString.CompareOptions = []
    ) -> String {
    
        self = self.regexSub(pattern, with: replacement, options)
        return self
    }
    
    
    
}
