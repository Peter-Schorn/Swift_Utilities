import Foundation

public typealias RegexMatch = (
    fullMatch: String,
    range: Range<String.Index>,
    groups: [(match: String, range: Range<String.Index>)?]
)


/// Holds a regular expression pattern
/// and NSRegularExpression.Options.
/// Can be used on self.regexMatch and self.regexFindAll
public typealias RegexObject = (
    pattern: String,
    options: NSRegularExpression.Options
)


public extension String {
    
    /**
     Finds the first match for a regular expression pattern in a string.
     
     Same as String.regexFindAll but only returns the first match.
     See String.regexFindAll for example usage and full discussion.
     
     - Parameters:
        - pattern: Regular expression pattern.
        - options: Regular expression options, such as .caseInsensitive
     
     - Throws: If the regular expression pattern is invalid
     (e.g., unbalanced paraentheses). **Never** throws an error
     if no matches were found.
     
     - Returns: The regular expression match or nil if no match was found.
     */
    func regexMatch(
        _ pattern: String,
        _ options: NSRegularExpression.Options = []
    ) throws -> RegexMatch? {
        
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        
        let nsString = self as NSString

        if let result = regex.firstMatch(
            in: self, range: NSRange(location: 0, length: self.count)
        ) {
        
            var regexMatch: RegexMatch
            
            regexMatch.fullMatch = nsString.substring(
                with: result.range(at: 0)
            )
            regexMatch.range = self.openRange(
                Range(result.range)!, checkNegative: false
            )
            regexMatch.groups = []
            
            for match in 1..<result.numberOfRanges {
                let nsRange = result.range(at: match)
                
                if nsRange.location == NSNotFound {
                    regexMatch.groups.append(nil)
                }
                else {
                    // append the capture group text and the range thereof
                    let range = self.openRange(
                        Range(nsRange)!, checkNegative: false
                    )
                    let capturedText = nsString.substring(with: nsRange)
                    regexMatch.groups.append(
                        (match: capturedText, range: range)
                    )
                }
                
            }
            
            return regexMatch
            
        }
        
        return nil
    }

    /// See self.regexMatch(`_:_`)
    func regexMatch(
        _ regexObject: RegexObject
    ) throws -> RegexMatch? {
        
        return try self.regexMatch(
            regexObject.pattern, regexObject.options
        )
    }

    /**
     Finds all matches for a regular expression pattern in a string.
     
     - Parameters:
        - pattern: Regular expression pattern.
        - options: Regular expression options, such as .caseInsensitive
     
     - Throws: If the regular expression pattern is invalid
           (e.g., unbalanced parentheses). **Never** throws an error
           if no matches were found.
     
     - Returns: An array of tuples, each of which contains the full match,
       the range of the full match in the original text,
       and an array of the capture groups.
       
       Each capture group is an optional tuple containing the matched text
       and the range of the matched text, or nil if the group was not matched.
       
       The ranges returned by this function can be used in the subsript for
       the original text, or for string.replaceSubrange(_:with:) to modify the
       text.
     
       If no matches were found at all, returns nil, **not an empty array**.
     
     ```
     public typealias RegexMatch = (
         fullMatch: String,
         range: Range<String.Index>,
         groups: [(match: String, range: Range<String.Index>)?]
     )
     ```
     Example Usage:
     ```
     var inputText = "season 8, EPISODE 5; season 5, episode 20"
     let pattern = #"season (\d+), Episode (\d+)"#

     if let results = try! inputText.regexFindAll(
         pattern, [.caseInsensitive]
     ) {
         for result in results {
             print("fullMatch: '\(result.fullMatch)'")
             
             let capturedText = result.groups.map { captureGroup in
                 captureGroup!.match
             }
             
             print("Capture groups:", capturedText)
             print()
         }
         
         let firstResult = results[0]
         
         inputText.replaceSubrange(firstResult.range, with: "new value")
         
         print("replaced text: '\(inputText)'")
     }
     ```
     Output:
     ```
     // fullMatch: 'season 8, EPISODE 5'
     // Capture groups: ["8", "5"]
     //
     // fullMatch: 'season 5, episode 20'
     // Capture groups: ["5", "20"]
     //
     // replaced text: 'new value; season 5, episode 20'
     ```
     */
    func regexFindAll(
        _ pattern: String,
        _ options: NSRegularExpression.Options = []
    ) throws -> [RegexMatch]? {
        
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        
        let nsString = self as NSString
        
        let regexResults = regex.matches(
            in: self, range: NSRange(location: 0, length: self.count)
        )

        var allMatches: [RegexMatch] = []
        
        // for each full match
        for result in regexResults {
            
            var regexMatch: RegexMatch
            
            regexMatch.fullMatch = nsString.substring(
                with: result.range(at: 0)
            )
            regexMatch.range = self.openRange(
                Range(result.range)!, checkNegative: false
            )
            regexMatch.groups = []
            
            // for each capture group
            for match in 1..<result.numberOfRanges {
                
                let nsRange = result.range(at: match)
                
                if nsRange.location == NSNotFound {
                    regexMatch.groups.append(nil)
                }
                
                else {
                    let capturedTextRange = self.openRange(
                        Range(nsRange)!, checkNegative: false
                    )
                    
                    let capturedText = nsString.substring(with: nsRange)
                    
                    regexMatch.groups.append(
                        (match: capturedText, range: capturedTextRange)
                    )
                }
                
            }
            
            allMatches.append(regexMatch)
            
        }
        
        if allMatches.isEmpty { return nil }
        return allMatches
    }
    
    /// See self.regexFindAll(`_:`_)
    func regexFindAll(
        _ regexObject: RegexObject
    ) throws -> [RegexMatch]? {
        
        return try self.regexFindAll(
            regexObject.pattern, regexObject.options
        )
    }
    
    /**
     Performs a regular expression replacement.
     
     - Parameters:
       - pattern: Regular expression pattern.
       - with: The string to replace matching patterns with.
         defaults to an empty string.
       - options: The options for the regular expression
             .regularExpression will be added to these options
     - Returns: The new string. If no matches were found,
           the string is left unchanged.
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
    
    /// See self.regexSub(`_:with:`_:)
    mutating func regexSubInPlace(
        _ pattern: String,
        with replacement: String = "",
        _ options: NSString.CompareOptions = []
    ) {
    
        self = self.regexSub(pattern, with: replacement, options)
    }
    
    
    
    /**
     Splits the string by occurences of a pattern into an array.
     
     - Parameters:
       - pattern: A regular expression pattern.
       - options: Regular expression options.
       - ignoreEmptyMatches: If true, all empty strings will be
             removed from the array. If false, they will be included.
       - maxLength: The maximum length of the returned array.
             If nil (default), then the string is split
             on every occurence of the pattern.
     - Throws: If the regular expression is invalid. **Never** throws
           if no matches are found.
     - Returns: An array of strings split on each occurence of the pattern.
           If no occurences of the pattern are found, then a single-element
           array containing the entire string will be removed.
     */
    func regexSplit(
        _ pattern: String,
        _ options: NSRegularExpression.Options = [],
        ignoreEmptyMatches: Bool,
        maxLength: Int? = nil
    ) throws -> [String] {

        let regex = try NSRegularExpression(pattern: pattern, options: options)
    
        let matches = regex.matches(
            in: self, range: NSRange(0..<self.count)
        )
        
        let ranges =
            [startIndex..<startIndex] +
            matches.map{ Range($0.range, in: self)! } +
            [endIndex..<endIndex]
        
        // let max = maxLength ?? matches.count
        let max: Int
        if let maxLength = maxLength {
            max = Swift.min(maxLength - 1, matches.count)
        }
        else {
            max = matches.count
        }
        
        return (0...max).compactMap {
            let item = String(
                self[ranges[$0].upperBound..<ranges[$0+1].lowerBound]
            )
            if item.isEmpty && ignoreEmptyMatches { return nil }
            return item
        }
        
    }
    
    
}