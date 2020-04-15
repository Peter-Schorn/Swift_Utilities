
import Foundation
import SwiftUI


public func UtilitiesTest() {
    print("hello from the utilities package!")
}

/// does nothing
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
 Converts a time unit to seconds
 
 For example:
     
     timeUnit(.hour(2)) == 7200
 
 Accepts this enum:

     enum TimeUnits {
         case minute(Double)
         case hour(Double)
         case day(Double)
         case week(Double)
         case year(Double)
     }

 */
public func timeUnit(_ unit: TimeUnits) -> Double {
    switch unit {
        case .minute(let t):
            return t * 60
        case .hour(let t):
            return t * 3600
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


#if os(macOS)
/**
 runs a shell script and returns the output with the trailing new line stripped
 - Parameters:
   - args: a list of arguments to run
   - launchPath: the path from which to launch the script. Default is /usr/bin/env
 - Returns: the output as String?
 */
public func runShellScript(
    args: [String], launchPath: String = "/usr/bin/env"
) -> String? {
    
    // Create a Task instance
    let task = Process()

    // Set the task parameters
    task.launchPath = launchPath
    task.arguments = args
     
    // Create a Pipe and make the task
    // put all the output there
    let pipe = Pipe()
    task.standardOutput = pipe

    // Launch the task
    task.launch()

    // Get the data
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let nsOutput = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    let output = nsOutput as String?
    return output?.strip()
    

}
#endif



#if os(iOS)
extension Color {

    public init(hex: String) {

        var hex = hex
        if hex.hasPrefix("#") { hex.removeFirst() }

        let r, g, b, a: CGFloat
        var hexNumber: UInt64 = 0
        let scanner = Scanner(string: hex)

        scanner.scanHexInt64(&hexNumber)
        
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255

        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        self.init(color)
    }
    
}
#endif


/// returns true if any of the arguments are true
public func any(_ expressions: Bool...) -> Bool {
    for i in expressions {
        if i { return true }
    }
    return false
}

/// returns true if all of the arguments are true
public func all(_ expressions: Bool...) -> Bool {
    for i in expressions {
        if !i { return false }
    }
    return true
}
