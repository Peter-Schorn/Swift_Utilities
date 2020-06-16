//
//  File.swift
//  
//
//  Created by Peter Schorn on 6/15/20.
//

import Foundation

/// Lazily splits a string on each occurence of a character or characters
/// into a lazy sequence.
public struct LazyStringSplit: LazySequenceProtocol, IteratorProtocol {

    public typealias Element = String
    public typealias Iterator = Self

    public private(set) var finished = false
    var iterator: String.Iterator
    public let delimiters: [Character]
    
    init(_ sourceString: LazySequence<String>, delimiters: [Character]) {
        self.iterator = sourceString.makeIterator()
        self.delimiters = delimiters
    }

    public mutating func next() -> String? {

        var line = ""
        while let char = iterator.next() {
            if delimiters.contains(char) {
                print("returning next line")
                return line
            }
            
            line.append(char)
        }
        if !finished {
            finished = true
            print("returning next line")
            return line
        }
        return nil
       
    }
    
    
}

public extension LazySequence where Base == String {
    
    /// Returns a lazy sequence of each line of the string.
    ///
    /// Supported new line delimiters are
    /// - U+000A (line feed)
    /// - U+000D (carriage return)
    /// - U+0085 (next line)
    /// - U+2028 (line separator)
    /// - U+2029 (paragraph separator)
    func lines() -> LazyStringSplit {
        return self.split(
            separatedBy: "\u{000A}", "\u{000D}", "\u{0085}", "\u{2028}", "\u{2029}"
        )
    }
    
    /// Returns a lazy sequence in which self is split on any of the specified characters.
    func split(separatedBy characters: [Character]) -> LazyStringSplit {
        return LazyStringSplit(self, delimiters: characters)
    }
    
    /// Returns a lazy sequence in which self is split on any of the specified characters.
    func split(separatedBy characters: Character...) -> LazyStringSplit {
        return split(separatedBy: characters)
    }
    
    
}
