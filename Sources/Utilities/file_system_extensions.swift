//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/26/20.
//

import Foundation

public func isExistingDirectory(_ path: URL) -> Bool {
    
    return (try? path.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    
}

public func isExistingFile(_ path: URL) -> Bool {
    
    if FileManager.default.fileExists(atPath: path.path) {
        let isDir = (try? path.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory
        return !(isDir ?? false)
        
    }
    return false
}


/// Wrapper for FileManager.default.createDirectory
public func makeFolder(
    _ path: URL,
    makeIntermediates: Bool = true,
    attributes: [FileAttributeKey:Any]? = nil
) throws {

    try FileManager.default.createDirectory(
        at: path,
        withIntermediateDirectories: makeIntermediates,
        attributes: attributes
    )
    
}

/// Renames a file or folder.
/// Equivalent to calling FileManager.default.moveItem(at:to:),
/// but only changing the last component of the path.
public func renameFile(_ path: URL, to newName: String) throws {
    
    var newPath = path.deletingLastPathComponent()
    newPath.appendPathComponent(newName)
    
    try FileManager.default.moveItem(at: path, to: newPath)
    
}


public enum DeleteOptions {
    case afterClosure
    case useHandler
}

// MARK: - macOS -
#if os(macOS)

/**
 Creates a temporary directory and passes the URL for it into a closure.
 
 Errors encountered when creating the directory are propogated back to the caller.
 Errors encountered when deleting the directory are silently ignored.
 
 See `FileManager.default.url(for:in:appropriateFor:create:)` for
 a disucssion of the directory, domain, and url parameters, which are
 forwarded through to that function.
 
 - Parameters:
   - deleteOptions:
     - .afterClosure: Deletes the directory immediately after the closure
           returns and sets `delelteClosure` to nil.
     - .useHandler: Provides `delelteClosure`, which deletes the directory.
           This is useful for asynchronous code.
   - closure: Executes after the temporary directory is created.
         If deleteOptions == .afterClosure, then `delelteClosure` is nil
   - tempDir: Executes after the directory is created.
   - delelteClosure: Deletes the directory when called.
 - Returns: The URL of the directory, which may have already been deleted,
       depending on the options specified above.
 */
@discardableResult
public func withTempDirectory(
   for directory: FileManager.SearchPathDirectory = .itemReplacementDirectory,
   in domain: FileManager.SearchPathDomainMask = .userDomainMask,
   appropriateFor url: URL = FileManager.default.homeDirectoryForCurrentUser,
   deleteOptions: DeleteOptions = .afterClosure,
   closure: (_ tempDir: URL, _ delelteClosure: (() -> Void)?) -> Void
) throws -> URL {

    let tempDir = try FileManager.default.url(
        for: directory,
        in: domain,
        appropriateFor: url,
        create: true
    )
    
    let deletionClosure = {
        do {
            try FileManager.default.removeItem(at: tempDir)

        } catch { }
    }
    
    switch deleteOptions {
        case .afterClosure:
            closure(tempDir, nil)
            deletionClosure()
        case .useHandler:
            closure(tempDir, deletionClosure)
    }
    
    return tempDir
}

/// Creates a Temporary directory for the current user.
public func createTempDirectory(
    for directory: FileManager.SearchPathDirectory = .itemReplacementDirectory,
    in domain: FileManager.SearchPathDomainMask = .userDomainMask,
    appropriateFor url: URL = FileManager.default.homeDirectoryForCurrentUser
) throws -> URL {
 
    return try FileManager.default.url(
        for: directory,
        in: domain,
        appropriateFor: url,
        create: true
    )
    
}

#endif
