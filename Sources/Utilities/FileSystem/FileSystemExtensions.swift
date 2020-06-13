import Foundation

public func isExistingDirectory(_ path: URL) -> Bool {
    
    return (
        try? path.resourceValues(forKeys: [.isDirectoryKey])
    )?.isDirectory ?? false
    
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
///
/// Equivalent to calling FileManager.default.moveItem(at:to:),
/// but only changing the last component of the path.
/// - Parameters:
///   - path: The path of the file/folder that needs to be renamed.
///   - newName: The new name.
/// - Throws: If there is an error renaming the file/folder.
public func renameFile(_ path: URL, to newName: String) throws {
    
    var newPath = path.deletingLastPathComponent()
    newPath.appendPathComponent(newName)
    
    try FileManager.default.moveItem(at: path, to: newPath)
    
}


/**
 Creates a temporary directory and passes the URL for it
 into `body`. After `body` returns, the directory is deleted.

 See `FileManager.default.url(for:in:appropriateFor:create:)` for
 a disucssion of the directory, domain, and url parameters, which are
 forwarded through to that function. The default values for these parameters
 should be sufficient for the majority of use cases.
 
 - Parameters:
   - body: A closure that takes the URL of the directory as its argument.
           After `body` returns, the temporary directory is deleted.
   - tempDir: The URL for the temporary directory.
 
 - Throws: If an error is encountered when creating the directory.
       **Errors encountered when deleting the directory are silently ignored.**
 */
@available(iOS 10.0, macOS 10.12, *)
public func withTempDirectory(
   for directory: FileManager.SearchPathDirectory = .itemReplacementDirectory,
   in domain: FileManager.SearchPathDomainMask = .userDomainMask,
   appropriateFor url: URL = FileManager.default.temporaryDirectory,
   body: (_ tempDir: URL) -> Void
) throws {

    let tempDir = try FileManager.default.url(
        for: directory,
        in: domain,
        appropriateFor: url,
        create: true
    )
    
    body(tempDir)
    
    try? FileManager.default.removeItem(at: tempDir)
    
}

/**
 Creates a Temporary directory for the current user.

 Body of function:
 ```
 return try FileManager.default.url(
     for: FileManager.SearchPathDirectory.itemReplacementDirectory,
     in: FileManager.SearchPathDomainMask.userDomainMask,
     appropriateFor: FileManager.default.temporaryDirectory,
     create: true
 )
 ```
 */
@available(iOS 10.0, macOS 10.12, *)
public func createTempDirectory() throws -> URL {
 
    return try FileManager.default.url(
        for: FileManager.SearchPathDirectory.itemReplacementDirectory,
        in: FileManager.SearchPathDomainMask.userDomainMask,
        appropriateFor: FileManager.default.temporaryDirectory,
        create: true
    )
    
}
