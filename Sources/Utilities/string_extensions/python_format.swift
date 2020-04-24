//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/23/20.
//

// Adds python-style format method for strings

import Foundation


/// replaces double brackets with single brackets
func removeDoubleBrackets(_ string: inout String) {
    string.regexSubInPlace(#"\{\{"#, with: "{")
    string.regexSubInPlace(#"\}\}"#, with: "}")
}

public extension String {
    
    
    func format(dict: [String: Any]) -> String {
        
        let items = dict.mapValues { "\($0)" }
        
        guard let keys = self.regexFindAll(#"(?<!\{)\{(?!\{)(.*?)(?<!\})\}(?!\})"#) else {
            fatalError("couldn't find dictionary keys in string")
        }
        
        var formattedStr = self
        var offset = 0
        
        for key in keys {
            
            // the keyword inside the curly bracket
            let kwarg = key.groups[0]!
            
            guard let item = items[kwarg] else {
                fatalError("couldn't find key in dictionary")
            }

            let range = offsetStrRange(formattedStr, range: key.range, by: offset)
            formattedStr.replaceSubrange(range, with: item)
            
            offset += (item.count - key.fullMatch.count)
        }
        
        removeDoubleBrackets(&formattedStr)
        return formattedStr
        
    }
    
    
    func format(_ interpolations: Any...) -> String {
        
        let items = interpolations.map { "\($0)" }
        guard let matches = self.regexFindAll(#"(?<!\{)\{(?!\{)(\d*)(?<!\})\}(?!\})"#) else {
            fatalError("couldn't find curly brackets")
        }

        // if all the curly brackets have numbers in them
        if matches.all({ $0.groups[0]!.regexMatch(#"\d+"#) != nil }) {
            // print("all numbers")
            return formatNum(items, matches)
        }
        
        // if all the curly brackets are empty
        if matches.all({ $0.fullMatch == "{}" }) {
            // print("all empty brackets")
            return formatPos(items, matches)
        }
                
        fatalError("all brackets should be empty, or they should all contain numbers.")
        
    }
    
    
    /// formats based on empty curly brackets
    private func formatPos(
        _ items: [String],
        _ matches: [RegexTuple]
    ) -> String {
        
        var formattedStr = self
        var offset = 0
        
        for (item, match) in zip(items, matches) {
            
            let range = offsetStrRange(formattedStr, range: match.range, by: offset)

            formattedStr.replaceSubrange(range, with: item)

            offset += (item.count - match.fullMatch.count)
        }

        removeDoubleBrackets(&formattedStr)
        return formattedStr
                
    }
    
    
    /// formats based on curly brackets with numbers inside them
    private func formatNum(
        _ items: [String],
        _ matches: [RegexTuple]
    ) -> String {
    
        var formattedStr = self
        var offset = 0
    
        for match in matches {
    
            // the number inside the brackets
            let num = Int(match.groups[0]!)!
            
            guard let item = items[safe: num] else {
                fatalError("item \(num) specified in curly brackets not found")
            }
    
            let range = offsetStrRange(formattedStr, range: match.range, by: offset)
            
            // print(formattedStr[match.range])
            formattedStr.replaceSubrange(range, with: item)

            
            offset += (item.count - match.fullMatch.count)
            
        }

        removeDoubleBrackets(&formattedStr)
        return formattedStr
    }
    
    
}
