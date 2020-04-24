//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/23/20.
//

import Foundation


public typealias RegexTuple = (
    fullMatch: String, range: Range<String.Index>, groups: [String]
)

public extension String {
    
    
    /**
     Finds the first match for a regular expression pattern in a string.
     
     - Attention: Same as String.regexFindAll but only returns the first match.
       See String.regexFindAll for example usage and full discussion.
     
     - Parameters:
        - pattern: Regular expression pattern.
        - options: Regular expression options, such as .caseInsensitive
        
     */
    func regexMatch(
        _ pattern: String,
        _ options: NSRegularExpression.Options = []
    ) -> RegexTuple? {
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            fatalError("invalid regex")
        }
        
        let nsString = self as NSString

        
        if let result = regex.firstMatch(
            in: self, options: [], range: NSMakeRange(0, nsString.length)
        ) {
        
            var regexTuple: RegexTuple
            
            regexTuple.fullMatch = nsString.substring(with: result.range(at: 0))
            regexTuple.range = self.strOpenRange(Range(result.range)!, checkNegative: false)
            regexTuple.groups = []
            
            for match in 1..<result.numberOfRanges {
                let range = result.range(at: match)
                if range.location == NSNotFound { continue }
                regexTuple.groups.append(nsString.substring(with: range ))
                
            }
            
            return Optional(regexTuple)
            
        }
        
        
        return nil
    }


    /**
     Finds all matches for a regular expression pattern in a string.
     
     - Parameters:
        - pattern: Regular expression pattern.
        - options: Regular expression options, such as .caseInsensitive
     
     - Returns: An array of tuples, each of which contains the full match,
       the range of the full match, and an array of the capture groups.
       Returns nil if no matches were found.
     
     ```
     public typealias RegexTuple = (
         fullMatch: String, range: Range<String.Index>, groups: [String]
     )
     ```
     Example Usage:
     ```
     var text = "season 8, episode 5; season 5, episode 20"

     if let results = text.regexFindAll(#"season (\d+), episode (\d+)"#) {
         for result in results {
             print("fullMatch: \"\(result.fullMatch)\", groups: \(result.groups)")
         }

         text.replaceSubrange(results[0].range, with: "new value")
         print("replaced text:", text)
         
     }
     else {
         print("no matches")
     }
     ```
     Output:
     ```
     // fullMatch: "season 8, episode 5", groups: ["8", "5"]
     // fullMatch: "season 5, episode 20", groups: ["5", "20"]
     // replaced text: new value; season 5, episode 20
     ```
     */
    func regexFindAll(
        _ pattern: String,
        _ options: NSRegularExpression.Options = []
    ) -> [RegexTuple]? {
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            fatalError("invalid regex")
        }
        
        let nsString = self as NSString
        
        let results  = regex.matches(
            in: self, options: [], range: NSMakeRange(0, nsString.length)
        )

        var fullMatches: [RegexTuple] = []
        
        for result in results {
            
            var regexTuple: RegexTuple
            regexTuple.fullMatch = nsString.substring(with: result.range(at: 0))
            regexTuple.range = self.strOpenRange(Range(result.range)!, checkNegative: false)
            regexTuple.groups = []
            
            for match in 1..<result.numberOfRanges {
                let range = result.range(at: match)
                if range.location == NSNotFound { continue }
                regexTuple.groups.append(nsString.substring(with: range ))
                
            }
            fullMatches.append(regexTuple)
            
        }
        
        if fullMatches.isEmpty { return nil }
        return Optional(fullMatches)
    }
        
    func regexOLD(_ regex: String) -> [[String]]? {
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
    
    /// See regexSub
    mutating func regexSubInPlace(
        _ pattern: String,
        with replacement: String = "",
        _ options: NSString.CompareOptions = []
    ) {
    
        self = self.regexSub(pattern, with: replacement, options)
    }
    
    
    
    
    
}
