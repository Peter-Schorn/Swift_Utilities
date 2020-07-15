import Foundation


public let π = Double.pi


public enum CountryCode: String {
    case US
}


public extension Double {
    
   
    /**
     Alias for `String(format: specifier, self)`.
     see [String Format Specifiers](https://developer.a.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html)
     - Parameter specifier: string format specifier.
     - Returns: formatted string.
     */
    func format(_ specifier: String) -> String {
        return String(format: specifier, self)
    }

    enum FormatOption {
        case currency(CountryCode), stripTrailingZeros
    }
    
    /// Formats the double as a string according to a specifier.
    ///
    /// FormatOptions:
    /// - currency: prints the currency symbol for the specified country
    ///       and two digits after decimal. e.g., $5.99
    /// - stripTrailingZeros: removes **insignificant** trailing zeros.
    func format(_ specifier: FormatOption) -> String {
        
        switch specifier {
            case let .currency(country):
                switch country {
                    case .US:
                        return self.format("$%.2f")
                }
            case .stripTrailingZeros:
                return self.format("%g")
        }

    }

}


/// Calculates the factorial of an integer.
/// Throws a fatal error if the number is < 0.
public func factorial<N: BinaryInteger>(_ x: N) -> N {
    if x > 0 { return x * factorial(x - 1) }
    if x == 0 { return 1 }
    fatalError("cannot calculate the factorial of a negative number (got \(x))")
}

/// Performs modulo division on floating point numbers.
public func % <N: BinaryFloatingPoint>(lhs: N, rhs: N) -> N {
    lhs.truncatingRemainder(dividingBy: rhs)
}


/**
 Tests whether two numbers are close to each other.
 - Parameters:
   - a: The first number.
   - b: The second numer.
   - rel_tol: The maximum allowed difference between a and b, relative to
         the percentage of the larger absolute value of a or b. Default: 0.
         **Must be greater than or equal to 0**. E.g., 0.05 represents 5%.
   - abs_tol: The maximum allowed absolute difference between a and b.
         Leave as nil to use the default: `max(a, b).ulp`.
         **Must be greater than or equal to 0**.
 - Returns: true if the values are within **one or both** of the specified tolerances.

 Uses the following boolean expression:
 ```
 abs(a - b) <= max(rel_tol * max(abs(a), abs(b)), abs_tol)
 ```
 This function is identical to Python's [math.isclose](https://docs.python.org/3/library/math.html?highlight=isclose#math.isclose)
 */
public func numsAreClose<N: FloatingPoint>(
    _ a: N, _ b: N, rel_tol: N = 0, abs_tol: N? = nil
) -> Bool {

    let absTol = abs_tol ?? max(a, b).ulp
    
    precondition(
        rel_tol ≥ 0,
        "numsAreClose: relative tolerance must be"
        + " greater than or equal to 0 (got \(rel_tol))"
    )
    precondition(
        absTol ≥ 0,
        "numsAreClose: absolute tolerance must be"
        + " greater than or equal to 0 (got \(rel_tol))"
    )
    
    if a == b { return true }
    
    return abs(a - b) ≤ max(rel_tol * max(abs(a), abs(b)), absTol)
    
}

/**
Tests whether two numbers are close to each other.
- Parameters:
  - a: The first number.
  - b: The second numer.
  - rel_tol: The maximum allowed difference between a and b, relative to
        the percentage of the larger absolute value of a or b. Default: 0.
        **Must be greater than or equal to 0**. E.g., 0.05 represents 5%.
  - abs_tol: The maximum allowed absolute difference between a and b.
        Leave as nil to use the default: `max(a, b).ulp`.
        **Must be greater than or equal to 0**.
- Returns: true if the values are within **one or both** of the specified tolerances.

Uses the following boolean expression:
```
abs(a - b) <= max(rel_tol * max(abs(a), abs(b)), abs_tol)
```
This function is identical to Python's [math.isclose](https://docs.python.org/3/library/math.html?highlight=isclose#math.isclose)
*/
public func numsAreClose<N: BinaryInteger, F: FloatingPoint>(
    _ a: N, _ b: N, rel_tol: F = 0, abs_tol: F = 0
) -> Bool {
    
    return numsAreClose(F(a), F(b), rel_tol: rel_tol, abs_tol: abs_tol)
}
