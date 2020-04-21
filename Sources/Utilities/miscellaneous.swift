
import Foundation
import SwiftUI

public func UtilitiesTest() {
    print("hello from the utilities package!")
}

/// Does nothing
public func pass() { }

public func currentTime() -> String {
    let date = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.timeStyle = .medium
    let dateTimeString = timeFormatter.string(from: date)
    return dateTimeString + "\n"
}

public extension Date {
    /// Alias for `timeIntervalSince1970`
    var unixTime: Double {
        return self.timeIntervalSince1970
    }
}

public func sleep<N: BinaryInteger>(_ interval: N) {
    sleep(UInt32(interval))
}

/// Accepts a sequence as input and forwards it to the print function
/// as a variadic parameter.
public func unpackPrint(
    _ items: [Any], separator: String = " ", terminator: String = "\n"
) {
    unsafeBitCast(
        print, to: (([Any], String, String) -> Void).self
    )(items, separator, terminator)
}


public enum TimeUnits {
    case minute(Double)
    case hour(Double)
    case day(Double)
    case week(Double)
    case year(Double)
    case month(Double, days: Int)
}

/**
 Converts a time unit to seconds.
 Allows for representing them in a more human-readable manner
 
 For example:
     
     timeUnit(.hour(2)) == 7200
 
 Accepts this enum:

     public enum TimeUnits {
         case minute(Double)
         case hour(Double)
         case day(Double)
         case week(Double)
         case year(Double)
         case month(Double, days: Int)
     }
 */
public func timeUnit(_ unit: TimeUnits) -> Double {
    switch unit {
        case .minute(let t):
            return t * 60
        case .hour(let t):
            return t * 3_600
        case .day(let t):
            return t * 86_400
        case .week(let t):
            return t * 604_800
        case .year(let t):
            return t * 31_536_000
        case .month(let t, days: let d):
            return t * Double(d) * 86_400
    }
}



/// Wrapper for DispatchQueue.main.asyncAfter
/// - Parameters:
///   - delay: The delay after which to execute the closure
///   - work: The closure to execute
public func asyncAfter(delay: Double, _ work: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
}



/// Returns true if any of the arguments are true
public func any(_ expressions: Bool...) -> Bool {
    for i in expressions {
        if i { return true }
    }
    return false
}

/// Returns true if all of the arguments are true
public func all(_ expressions: Bool...) -> Bool {
    for i in expressions {
        if !i { return false }
    }
    return true
}
