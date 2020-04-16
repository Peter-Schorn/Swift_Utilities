//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/16/20.
//

import Foundation

#if os(macOS)
/// Wrapper for FileManager.default.createDirectory
func makeFolder(
    _ path: String,
    makeIntermediates: Bool = true,
    attributes: [FileAttributeKey:Any]? = nil
) throws {

    try FileManager.default.createDirectory(
        atPath: path,
        withIntermediateDirectories: makeIntermediates,
        attributes: attributes
    )
}


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
