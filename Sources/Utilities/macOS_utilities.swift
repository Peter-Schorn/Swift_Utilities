//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/16/20.
//

import Foundation

#if os(macOS)

/**
 Runs a shell script and returns the output.
 
 - Parameters:
   - args: a list of arguments to run
   - launchPath: the path from which to launch the script. Default is /usr/bin/env
   - stdout: Pipe for the standard output. If nil (default) then a new pipe
        will be created.
   - stderror: Pipe for standard error. If nil (default) then a new pipe
        will be created.
 - Returns: A tuple containing String? for the output and for the error.
 */
public func runShellScript(
    args: [String],
    launchPath: String = "/usr/bin/env",
    stdout: Pipe? = nil,
    stderror: Pipe? = nil
) -> (stdout: String?, stderror: String?) {
    
    // Create a Task instance
    let task = Process()

    // Set the task parameters
    task.launchPath = launchPath
    task.arguments = args
     
    // Create Pipes
    let standardOutput  = stdout ?? Pipe()
    task.standardOutput = standardOutput
    
    let standardError   = stderror ?? Pipe()
    task.standardError  = standardError

    // Launch the task
    task.launch()

    // Get the data
    let stdoutData = standardOutput.fileHandleForReading.readDataToEndOfFile()
    let nsStdoutOutput = NSString(data: stdoutData, encoding: String.Encoding.utf8.rawValue)
    let stdoutOutput = (nsStdoutOutput as String?)?.strip()
    
    let stderrorData = standardError.fileHandleForReading.readDataToEndOfFile()
    let nsStderrorOutput = NSString(data: stderrorData, encoding: String.Encoding.utf8.rawValue)
    let stderrorOutput = (nsStderrorOutput as String?)?.strip()
    
    
    return (stdout: stdoutOutput, stderror: stderrorOutput)
    
}

#endif
