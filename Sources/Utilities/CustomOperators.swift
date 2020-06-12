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

// MARK: - Exponent Operator -

precedencegroup ExponentiativePrecedence {
  associativity: right
  higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiativePrecedence

/// exponent operator
public func ** <N: BinaryInteger>(base: N, power: N) -> N {
    return N.self(pow(Double(base), Double(power)))
}

/// exponent operator
public func ** <N: BinaryFloatingPoint>(base: N, power: N) -> N {
    return N.self(pow(Double(base), Double(power)))
}

// MARK: - Exponent Assignment Operator -

infix operator **= : ExponentiativePrecedence

/**
 exponent assignment operator
 ```
 var x = 5
 x **= 2
 // x is now 25
 ```
 */
public func **= <N: BinaryInteger>(lhs: inout N, rhs: N) {
    lhs = lhs ** rhs
}

/**
exponent assignment operator
```
var x = 5
x **= 2
// x is now 25
```
*/
public func **= <N: BinaryFloatingPoint>(lhs: inout N, rhs: N) {
    lhs = lhs ** rhs
}

// MARK: - Square Root Operator -

prefix operator √

public prefix func √ <N: FloatingPoint>(_ radicand: N) -> N {
    return sqrt(radicand)
}

// MARK: - Pattern Matching Overload -
/// This overload of the pattern matching operator allows
/// functions that return Bool to be used in switch statements
/// if they accept a single argument that corresponds the type of the
/// value being switched on.
///
/// - Parameters:
///   - pattern: The function that accepts the value being switched on
///   - value: the value being switched on in a switch statement
public func ~=<T>(pattern: (T) -> Bool, value: T) -> Bool {
    return pattern(value)
}


// MARK: - Range Offset Operators -

/// Offsets a range by a given amount.
public func +=<Bound: Numeric>(range: inout Range<Bound>, offset: Bound) {
    range = (range.lowerBound + offset)..<(range.upperBound + offset)
}

/// Offsets a range by a given amount.
public func -=<Bound: Numeric>(range: inout Range<Bound>, offset: Bound) {
    range = (range.lowerBound - offset)..<(range.upperBound - offset)
}


/// Offsets a range by a given amount.
public func +=<Bound: Numeric>(range: inout ClosedRange<Bound>, offset: Bound) {
    range = (range.lowerBound + offset)...(range.upperBound + offset)
}

/// Offsets a range by a given amount.
public func -=<Bound: Numeric>(range: inout ClosedRange<Bound>, offset: Bound) {
    range = (range.lowerBound - offset)...(range.upperBound - offset)
}


/// Offsets a range by a given amount.
public func +=<Bound: Numeric>(range: inout PartialRangeFrom<Bound>, offset: Bound) {
    range = (range.lowerBound + offset)...
}

/// Offsets a range by a given amount.
public func -=<Bound: Numeric>(range: inout PartialRangeFrom<Bound>, offset: Bound) {
    range = (range.lowerBound - offset)...
}


/// Offsets a range by a given amount.
public func +=<Bound: Numeric>(range: inout PartialRangeThrough<Bound>, offset: Bound) {
    range = ...(range.upperBound + offset)
}

/// Offsets a range by a given amount.
public func -=<Bound: Numeric>(range: inout PartialRangeThrough<Bound>, offset: Bound) {
    range = ...(range.upperBound - offset)
}


/// Offsets a range by a given amount.
public func +=<Bound: Numeric>(range: inout PartialRangeUpTo<Bound>, offset: Bound) {
    range = ..<(range.upperBound + offset)
}

/// Offsets a range by a given amount.
public func -=<Bound: Numeric>(range: inout PartialRangeUpTo<Bound>, offset: Bound) {
    range = ..<(range.upperBound - offset)
}
