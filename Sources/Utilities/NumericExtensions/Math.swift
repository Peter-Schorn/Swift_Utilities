import Foundation


/// Calculates the factorial of an integer.
/// Throws a fatal error if the number is negative.
public func factorial<N: BinaryInteger>(_ x: N) -> N {
    
    if x > 1 { return x * factorial(x - 1) }
    if [0, 1].contains(x) { return 1 }
    
    fatalError(
        "cannot calculate the factorial " +
        "of a negative number (got \(x))"
    )
}

/// Performs modulo division on floating point numbers.
public func % <N: BinaryFloatingPoint>(lhs: N, rhs: N) -> N {
    lhs.truncatingRemainder(dividingBy: rhs)
}
