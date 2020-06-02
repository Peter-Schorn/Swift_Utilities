import Foundation


public typealias RegexMatch = (
    fullMatch: String,
    range: Range<String.Index>,
    groups: [String?]
)

public extension String {
    
        
    /// Returns an array of each line in the string
    func lines() -> [String] {
        
        return self.split(separator: "\n").map { String($0) }
        
    }
    
    /// Returns an array of each word in the string
    func words() -> [String] {
        
        if let matches = self.regexFindAll(#"\w+"#) {
            return matches.map { $0.fullMatch }
        }
        return []

    }
        
        
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
    ) -> RegexMatch? {
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            fatalError("invalid regex")
        }
        
        let nsString = self as NSString

        
        if let result = regex.firstMatch(
            in: self, options: [], range: NSMakeRange(0, nsString.length)
        ) {
        
            var regexTuple: RegexMatch
            
            regexTuple.fullMatch = nsString.substring(with: result.range(at: 0))
            regexTuple.range = self.openRange(Range(result.range)!, checkNegative: false)
            regexTuple.groups = []
            
            for match in 1..<result.numberOfRanges {
                let range = result.range(at: match)
                
                if range.location == NSNotFound {
                    regexTuple.groups.append(nil)
                }
                else {
                    regexTuple.groups.append(nsString.substring(with: range ))
                }
                
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
       the range of the full match, and an array of the capture groups [String?].
       If one of the capture groups was not matched, then it will be nil.
       Returns nil if no matches were found.
     
     ```
     public typealias RegexTuple = (
         fullMatch: String,
         range: Range<String.Index>,
         groups: [String?]
     )
     ```
     Example Usage:
     ```
     var text = "season 8, episode 5; season 5, episode 20"

     if let results = text.regexFindAll(#"season (\d+), episode (\d+)"#) {
         for result in results {
             print("fullMatch: \"\(result.fullMatch)\", groups: \(result.groups)")
         }

         text.replaceSubrange(results[0]!.range, with: "new value")
         print("replaced text:", text)
         
     }
     else {
         print("no matches")
     }
     ```
     Output:
     ```
     // fullMatch: "season 8, episode 5", groups: [Optional("8"), Optional("5")]
     // fullMatch: "season 5, episode 20", groups: [Optional("5"), Optional("20")]
     // replaced text: new value; season 5, episode 20
     ```
     */
    func regexFindAll(
        _ pattern: String,
        _ options: NSRegularExpression.Options = []
    ) -> [RegexMatch]? {
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            fatalError("invalid regex")
        }
        
        let nsString = self as NSString
        
        let results  = regex.matches(
            in: self, options: [], range: NSMakeRange(0, nsString.length)
        )

        var fullMatches: [RegexMatch] = []
        
        for result in results {
            
            var regexTuple: RegexMatch
            regexTuple.fullMatch = nsString.substring(with: result.range(at: 0))
            regexTuple.range = self.openRange(Range(result.range)!, checkNegative: false)
            regexTuple.groups = []
            
            for match in 1..<result.numberOfRanges {
                let range = result.range(at: match)
                
                if range.location == NSNotFound {
                    regexTuple.groups.append(nil)
                }
                else {
                    regexTuple.groups.append(nsString.substring(with: range ))
                }
                
            }
            fullMatches.append(regexTuple)
            
        }
        
        if fullMatches.isEmpty { return nil }
        return Optional(fullMatches)
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
