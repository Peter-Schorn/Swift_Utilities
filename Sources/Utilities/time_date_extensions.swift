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
    init(unixTime: Double) {
        self.init(timeIntervalSince1970: unixTime)
    }
    
    /// Returns the difference between the dates in seconds
    static func - (lhs: Date, rhs: Date) -> Double {
        return lhs.unixTime - rhs.unixTime
    }
    
    /// Adds the unix time for the dates together
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



public class StopWatch {

    private(set) var startTime: Double?
    private(set) var isPaused = true
    private var _timeElapsed: Double = 0
    
    /// if startNow is set to true, then the stopWatch
    /// is started upon instantiation.
    public init(startNow: Bool = false) {
        if startNow {
            self.resume()
        }
    }
    
    /// Returns the amount of time on the stopWatch.
    /// This method can be called when the stopWatch is running
    /// and when it is paused.
    public var timeElapsed: Double {
        if self.isPaused {
            return self._timeElapsed
        }
        if let start = self.startTime {
            return Date().unixTime - start + self._timeElapsed
        }
        return 0
    }
    
    /// Resumes the stopWatch. By default, the stopWatch is instantiated
    /// in a paused state. Calling resume for the first time
    /// starts the stopWatch. If the stopWatch was not paused, then
    /// this method has no effect.
    public func resume() {
        if self.isPaused {
            self.startTime = Date().unixTime
            self.isPaused = false
        }
    }
    
    /// Pauses the stopWatch. If the stopWatch was already paused,
    /// then this method has no effect.
    public func pause() {
        if !self.isPaused {
            if let start = self.startTime {
                self._timeElapsed += Date().unixTime - start
            }
            self.isPaused = true
        }
    }
    
    /// Toggles the stopWatch between paused and unpaused.
    public func toggle() {
        if self.isPaused {
            self.resume()
        }
        else {
            self.pause()
        }
    }
    
    /// sets timeElapsed to 0 and pauses the stopWatch.
    public func reset() {
        self.startTime = nil
        self._timeElapsed = 0
        self.isPaused = true
    }
    
    
}

