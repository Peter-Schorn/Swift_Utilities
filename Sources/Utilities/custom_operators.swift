import Foundation

// test

infix operator ≥: ComparisonPrecedence

public func ≥ <N: Comparable>(lhs: N, rhs: N) -> Bool {
    return lhs >= rhs
}

infix operator ≤: ComparisonPrecedence
public func ≤ <N: Comparable>(lhs: N, rhs: N) -> Bool {
    return lhs <= rhs
}


precedencegroup Exponentiative {
  associativity: left
  higherThan: MultiplicationPrecedence
}

infix operator ** : Exponentiative

/// exponent operator
public func ** <N: BinaryInteger>(base: N, power: N) -> N {
    return N.self( pow(Double(base), Double(power)) )
}

/// exponent operator
public func ** <N: BinaryFloatingPoint>(base: N, power: N) -> N {
    return N.self ( pow(Double(base), Double(power)) )
}


precedencegroup ExponentiativeAssignment {
  associativity: right
  higherThan: MultiplicationPrecedence
}


infix operator **= : ExponentiativeAssignment

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
