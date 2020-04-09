
import Foundation


/// Incrementally raises a number to a power until
/// it is greater than max
struct Exponetiate<N: BinaryFloatingPoint>:
    Sequence, IteratorProtocol
{
    
    var start: N
    let power: N
    let max: N
    
    init(start: N, power: N, max: N) {
        self.start = start
        self.power = power
        self.max   = max
    }

    mutating func next() -> N? {
        
        if start < max {
            let current = start
            start **= power
            return current
        }
        return nil
        
    }
}
