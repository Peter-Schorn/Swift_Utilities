//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/16/20.
//

import Foundation

#if os(macOS)

public extension Pipe {
    
    func asString(encoding: String.Encoding = .utf8) -> String? {
        let data = self.fileHandleForReading.readDataToEndOfFile()
        let string = String(data: data, encoding: encoding)
        return string?.strip()
    }
    
}


/**
 Runs a shell script and returns the output.
 
 - Parameters:
   - args: a list of arguments to run
   - launchPath: the path from which to launch the script. Default is /usr/bin/env
   - stdout: Pipe for the standard output. Default is a new pipe.
   - stderror: Pipe for standard error. Default is a new pipe.
 - Returns: A tuple containing String? for the output and for the error,
     and the exit code.
 
 - Warning: Stdout and stderror are more likely to be empty strings than nil if no
 output is expected.
 
 Usage:
 ```
 let output = runShellScript(args: ["echo", "hello"])
 print(output)
 // (stdout: Optional("hello"), stderror: Optional(""), exitCode: 0)
 ```
 */
public func runShellScript(
    args: [String],
    launchPath: String = "/usr/bin/env",
    stdout: Pipe = Pipe(),
    stderror: Pipe = Pipe()
) -> (stdout: String?, stderror: String?, exitCode: Int) {

    // Create a Task instance
    let task = Process()

    // Set the task parameters
    task.launchPath = launchPath
    task.arguments = args
     
    // Create Pipes
    let standardOutput  = stdout
    task.standardOutput = standardOutput
    
    let standardError   = stderror
    task.standardError  = standardError

    // Launch the task
    task.launch()
    task.waitUntilExit()
    
    let status = Int(task.terminationStatus)
    
    return (
        stdout: standardOutput.asString(),
        stderror: standardError.asString(),
        exitCode: status
    )
    
}

/**
 Runs a shell script and registers a completion handler.
 
 - Parameters:
   - args: a list of arguments to run
   - launchPath: the path from which to launch the script. Default is /usr/bin/env
   - stdout: Pipe for the standard output. Default is a new pipe.
   - stderror: Pipe for standard error. Default is a new pipe.
   - terminationHandler: Passes in the process, stdout as String?, and stderror as
       as String?. Executed upon completion of the process.
 
 - Warning: Stdout and stderror are more likely to be empty strings than nil if no
     output is expected. Use process.terminationStatus from within the
     terminationHandler to check if the process exited normally.
 
 Usage:
 ```
 runShellScriptAsync(args: ["echo", "hello"]) { process, stdout, stderror in
     
     print("stdout:", stdout)
     print("stderror:", stderror)
     print("exit code:", process.terminationStatus)
 }
 // stdout: Optional("hello")
 // stderror: Optional("")
 // exit code: 0
 ```
 */
public func runShellScriptAsync(
    args: [String],
    launchPath: String = "/usr/bin/env",
    stdout: Pipe = Pipe(),
    stderror: Pipe = Pipe(),
    terminationHandler: ((Process, _ stdout: String?, _ stdout: String?) -> Void)? = nil
) {
    
    let terminationHandlerWrapper = { (process: Process) -> Void  in
        
        if let handler = terminationHandler {
            
            let stdout   = (process.standardOutput as! Pipe).asString()
            let stderror = (process.standardError  as! Pipe).asString()

            handler(process, stdout, stderror)
        }
    }
    
    // Create a Task instance
    let task = Process()

    // Set the task parameters
    task.launchPath = launchPath
    task.arguments = args
     
    // Create Pipes
    let standardOutput  = stdout
    task.standardOutput = standardOutput
    
    let standardError   = stderror
    task.standardError  = standardError

    task.terminationHandler = terminationHandlerWrapper
    
    // Launch the task
    task.launch()
    
}


#endif
