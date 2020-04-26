//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/26/20.
//

import Foundation


public func sleep<N: BinaryInteger>(_ interval: N) {
    sleep(UInt32(interval))
}


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
    
    /**
     Alias for
     `.init(timeIntervalSince1970: Double)`
     */
    public init(unixTime: Double) {
        self.init(timeIntervalSince1970: unixTime)
    }
    
    static func - (lhs: Date, rhs: Date) -> Double {
        return lhs.unixTime - rhs.unixTime
    }
    
    static func + (lhs: Date, rhs: Date) -> Double {
        return lhs.unixTime - rhs.unixTime
    }
    
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
 ```
 timeUnit(.hour(2)) == 7200
 ```
 Accepts this enum:
 ```
 public enum TimeUnits {
     case minute(Double)
     case hour(Double)
     case day(Double)
     case week(Double)
     case year(Double)
     case month(Double, days: Int)
 }
 ```
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
