
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


/**
 runs a shell script and returns the output with the trailing new line stripped
 - Parameters:
   - args: a list of arguments to run
   - launchPath: the path from which to launch the script. Default is /usr/bin/env
 - Returns: the output as String?
 */
#if os(macOS)
public func runShellScript(args: [String], launchPath: String = "/usr/bin/env") -> String? {
    
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
    let NSoutput = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    let output = NSoutput as String?
    return output?.stripped()
    

}
#endif


/**
 Property Wrapper that removes characters that match a regular expression pattern

 This example will remove all non-word characters from a string
 ```
 struct User {

     @InvalidChars(#"\W+"#) var username: String

     init(username: String) {
         self.username = username
     }

 }
 ```
 */
@propertyWrapper
public struct InvalidChars {
    
    private var value = ""
    public let regex: String
    
    public init(_ regex: String) {
        self.regex = regex
    }
    
    public init(wrappedValue: String, _ regex: String) {
        self.regex = regex
        self.value = wrappedValue
    }
    
    
    public var wrappedValue: String {
        get { return value }
        set { value = newValue.regexSub(regex) }
    }

}
public extension Sequence where Element: Numeric {
    
    /// return the sum of the elements in a sequence
    var sum: Element { self.reduce(0, +) }

}


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
