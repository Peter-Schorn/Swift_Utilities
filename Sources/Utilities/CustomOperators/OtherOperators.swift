import Foundation

// MARK: - Comparison Operators -

infix operator ≥ : ComparisonPrecedence

public func ≥ <N: Comparable>(lhs: N, rhs: N) -> Bool {
    return lhs >= rhs
}

infix operator ≤ : ComparisonPrecedence

public func ≤ <N: Comparable>(lhs: N, rhs: N) -> Bool {
    return lhs <= rhs
}


// MARK: - Pattern Matching Overload -

/**
 This overload of the pattern matching operator allows
 functions that return Bool to be used in switch statements
 if they accept a single argument that corresponds the type of the
 value being switched on.

 - Parameters:
   - pattern: The function that accepts the value being switched on.
   - value: The value being switched on in a switch statement.
 */
public func ~=<T>(pattern: (T) -> Bool, value: T) -> Bool {
    return pattern(value)
}


