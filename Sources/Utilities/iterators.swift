
import Foundation


/// Incrementally raises a number to a power.
///
/// if range == .open (default) then the loop continues until n `<` max.
/// if range == .closed then the loop continues until n `<=` max
struct exponetiate<N: BinaryFloatingPoint>:
    Sequence, IteratorProtocol
{

    enum RangeType { case open, closed }
    
    var start: N
    let power: N
    let max: N
    let cond: (N, N) -> Bool
    
    init(start: N, power: N, max: N, range: RangeType = .open) {

        self.start = start
        self.power = power
        self.max   = max
        self.cond = range == .open ? { $0 < $1} : { $0 ≤ $1 }
        
    }

    
    
    mutating func next() -> N? {
        
        if cond(start, max) {
            let current = start
            start **= power
            return current
        }
        return nil
        
    }
}


/**
 Generates a C-style iterator.
 In these closures, $0 is the current value of the iterator.

 # Parameters
 - init: The initial value
 - while:
    Executes after each iteration of the loop.
    the loop continues if it returns true and ends if it returns false
 - update: Used to update the value after each iteration
 
 In this example, i begins as 2 and is multiplied by two after each iteration.
 The iterator stops when i > 100
 ```
 for i in iterator(init: 2, while: { $0 <= 100 }, update: { $0 * 2 }) {
     print(i)
 }
 ```
 */
struct c_iterator<N: Numeric>:
    Sequence, IteratorProtocol
{

    var value: N
    let cond: (N) -> Bool
    let update: (N) -> N
    
    init(
        init value: N,
        while cond: @escaping (N) -> Bool,
        update: @escaping (N) -> N
    ) {
        self.value = value
        self.cond = cond
        self.update = update
    }
    
    mutating func next() -> N? {
        
        if cond(value) {
            let current = value
            value = update(value)
            return current
        }
        return nil
    }
    
}
