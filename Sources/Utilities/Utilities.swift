import Foundation
import SwiftUI

// 12:32PM

public func UtilitiesTest() {
    print("hello from the utilities package!")
}

/// does nothing
public func pass() { }

public func currentTime() -> String {
    let date = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.timeStyle = .medium
    let dateTimeString = timeFormatter.string(from: date)
    return dateTimeString + "\n"
}

// #################################################################

/**
 runs a shell script and returns the output with the trailing new line stripped
 - Parameters:
   - args: a list of arguments to run
   - launchPath: the path from which to launch the script. Default is /usr/bin/env
 - Returns: the output as String?
 */
#if os(macOS)
public func runShellScript(args: [String], launchPath: String = "/usr/bin/env") -> String? {
    
    // Create a Task instance
    let task = Process()

    // Set the task parameters
    task.launchPath = launchPath
    task.arguments = args
     
    // Create a Pipe and make the task
    // put all the output there
    let pipe = Pipe()
    task.standardOutput = pipe

    // Launch the task
    task.launch()

    // Get the data
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let NSoutput = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    let output = NSoutput as String?
    return output?.stripped()
    

}
#endif

// #################################################################

/// enables passing in negative indices to access characters
/// starting from the end and going backwards
func negative(_ num: Int, _ count: Int) -> Int {
    if num < 0 {
        return num + count
    }
    return num
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
    mutating func regexSubInplace(_ pattern: String, with: String = "") -> String {
        self = self.regexSub(pattern, with: with)
        return self
    }
    
    
    /// Removes trailing and leading white space.
    /// Alias for self.trimmingCharacters(in: .whitespacesAndNewlines)
    func stripped() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Strips trailing and leading white space **in place**
    mutating func strip() -> String {
        self = self.stripped()
        return self
    }

    /// alias for .components(separatedBy: separator)
    func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }
    
    
    
}

public extension Array {
    
    /// Splits array into array of arrays with specified size
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    /// Enables accessing elemnts from the end backwards
    /// [back: 1] returns the last element,
    /// [back: 2] returns the second last, and so on
    subscript(back i: Int) -> Element {
        get { return self[self.count - i] }
        set { self[self.count - i] = newValue }
    }
 
}


public extension Double {
    
    /**
     Strips trailing zeros and returns the string representation.
     
     Equivalent to
     ```
     String(format: "%g", self)
     ```
     */
    var stripTrailingZeros: String {
        return String(format: "%g", self)
    }
}


/**
 Property Wrapper that removes characters that match a regular expression pattern

 This example will remove all non-word characters from a string
 ```
 struct User {

     @InvalidChars(#"\W+"#) var username: String

     init(username: String) {
         self.username = username
     }

 }
 ```
 */
@propertyWrapper
public struct InvalidChars {
    
    private var value = ""
    public let regex: String
    
    public init(_ regex: String) {
        self.regex = regex
    }
    
    public init(wrappedValue: String, _ regex: String) {
        self.regex = regex
        self.value = wrappedValue
    }
    
    
    public var wrappedValue: String {
        get { return value }
        set { value = newValue.regexSub(regex) }
    }

}
public extension Sequence where Element: Numeric {
    
    /// return the sum of the elements in a sequence
    var sum: Element { self.reduce(0, +) }

}


#if os(iOS)
extension Color {

    public init(hex: String) {

        var hex = hex
        if hex.hasPrefix("#") { hex.removeFirst() }

        let r, g, b, a: CGFloat
        var hexNumber: UInt64 = 0
        let scanner = Scanner(string: hex)

        scanner.scanHexInt64(&hexNumber)
        
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255

        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        self.init(color)
    }
    
}
#endif
