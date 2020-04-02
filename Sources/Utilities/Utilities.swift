
import Foundation

public func UtilitiesTest() {
    print("hello from the utilities package!")
}


/// does nothing
public func pass() { }

infix operator ≥: ComparisonPrecedence
public func ≥ <N: Comparable>(lhs: N, rhs: N) -> Bool {
    return lhs >= rhs
}

infix operator ≤: ComparisonPrecedence
public func ≤ <N: Comparable>(lhs: N, rhs: N) -> Bool {
    return lhs <= rhs
}

// #################################################################

public func currentTime() -> String {
    let date = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.timeStyle = .medium
    let dateTimeString = timeFormatter.string(from: date)
    return dateTimeString + "\n"
}

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
    
    /// the following three subscripts add the ability to
    /// access singe characters and slices of strings
    /// as if they were an array of characters
    /// Usage: string[n] or string[n...n] or string[n..<n]
    /// where n is an integer
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

    /// Simplfies regular expressions
    /// Usage: String.regex(pattern)
    /// - Parameter regex: regular expression pattern
    /// - Returns: an array of matches or nil if none were found
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

    /// removes trailing and leading white space
    func strip() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}

public extension Array {
    
    /// Splits array into array of arrays with specified size
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
 
}

public extension Collection where Index: Comparable {

    /// Enables accessing elemnts from the end backwards
    /// [back: 1] returns the last element,
    /// [back: 2] returns the second last, and so on
    subscript(back i: Int) -> Iterator.Element {
        return self[self.index(self.endIndex, offsetBy: -i)]
    }
}
