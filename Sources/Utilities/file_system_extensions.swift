//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/26/20.
//

import Foundation


/// Wrapper for FileManager.default.createDirectory
public func makeFolder(
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
 Creates a temporary directory, passes the URL for it into a closure,
 and then deletes the directory after executing the closure.
 
 When the directory is being deleted, if it can't be found because, e.g.,
 it was already deleted from within the closure,
 then this error is silently ignored.
 All other errors are propogated back to the caller.
 See `FileManager.default.url(for:in:appropriateFor:create:)` for
 a disucssion of the parameters.
 */
@discardableResult
public func withTempDirectory(
   for directory: FileManager.SearchPathDirectory = .itemReplacementDirectory,
   in domain: FileManager.SearchPathDomainMask = .userDomainMask,
   appropriateFor url: URL = FileManager.default.homeDirectoryForCurrentUser,
   delete: Bool = true,
   closure: (URL) -> Void
) throws -> URL {

    let tempDir = try FileManager.default.url(
        for: directory,
        in: domain,
        appropriateFor: url,
        create: true
    )
    
    closure(tempDir)
    
    if delete {
        do {
            try FileManager.default.removeItem(at: tempDir)
        
        } catch let e as NSError where e.code == 4 {
            // code 4 indicates that the directory couldn't be found.
            print("WARNING: couldn't delete temp directory")
        }
    }
    
    return tempDir
}
