//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/23/20.
//

import Foundation

public extension String {
    
    
        /**
         Finds the first match for a regular expression patter in a string.
         
         - Parameters:
             - pattern: Regular expression pattern.
             - options: Regular expression options, such as .caseInsensitive
         - Returns: A tuple containing the match and the range of the match
           in the original string.
        
         See also String.regexFindAll
         */
        func regexMatch(
            _ pattern: String,
            _ options: NSRegularExpression.Options = []
        ) -> (match: String, range: Range<String.Index>)? {
            
            guard let regex = try? NSRegularExpression(
                pattern: pattern, options: options
            ) else {
                fatalError("invalid regex")
            }
            
            if let result = regex.firstMatch(in: self, range: NSMakeRange(0, self.count)) {
                
                let match = String(text[Range(result.range, in: text)!])
                let range = strOpenRange(Range(result.range)!)
                return (match: match, range: range)
            }
            return nil
        }

    
    /**
     Finds all matches for a regular expression pattern in a string.
     
     - Parameters:
        - pattern: Regular expression pattern.
        - options: Regular expression options, such as .caseInsensitive
     - Returns: An array of tuples containing the match and
       the range of the match in the original string, or nil if no matches are found
     
     Usage:
     ```
     var text = "one, two, three"
     if let results = text.regexFindAll(#"\w+"#, [.caseInsensitive]) {
         for result in results {
             print(result.match)
             text.replaceSubrange(result.range, with: "new value")
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
