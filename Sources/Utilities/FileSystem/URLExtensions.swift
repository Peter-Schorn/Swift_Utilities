import Foundation


public extension URL {

    /// Returns a new url with the specified query item appended to it.
    func appending(
        _ queryItem: URLQueryItem
    ) -> URL {

        guard var urlComponents = URLComponents(
            url: self, resolvingAgainstBaseURL: false
        ) else {
            fatalError(
                "trying to append query item: " +
                "couldn't get url components from url"
            )
        }

        // Create array of existing query items
        var currentQueryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        currentQueryItems.append(queryItem)


        // Append updated query items array in the url component object
        urlComponents.queryItems = currentQueryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
    
    func appending(page: Int) -> URL {
        return self.appending(URLQueryItem(name: "page", value: String(page)))
    }

    mutating func append(page: Int) {
        self = self.appending(page: page)
    }
    
    /// Appends a query item to the url
    mutating func append(_ queryItem: URLQueryItem) {
        self = self.appending(queryItem)
    }
    
    /// The last component of the path excluding the file extension.
    /// Calls self.lastPathComponent and strips all text after the last period.
    var lastPathName: String {
        return self.lastPathComponent.strip(.fileExt)
    }
    
    
    /// You tell me what the canonical path is.
    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    func canonicalPath() throws -> URL? {
        
        let resourceValues = try self.resourceValues(
            forKeys: [.canonicalPathKey]
        )
        
        if let path = resourceValues.canonicalPath {
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    
    /// The query items in the url.
    var queryItems: [URLQueryItem]? {
        return URLComponents(
            url: self, resolvingAgainstBaseURL: false
        )?.queryItems
        
    }

    /// A dictionary of the query items in the url.
    var queryItemsDict: [String: String]? {
        
        return self.queryItems?.reduce(into: [:]) { dict, query in
            dict[query.name] = query.value
        }
    }
    
}


/// If the url is an alias, returns the path that the alias points to.
/// Else, returns the original URL.
/// Throws an error if the file doesn't exist.
public func resolveAlias(at url: URL) throws -> URL {

    let resourceValues = try url.resourceValues(forKeys: [.isAliasFileKey])
    if resourceValues.isAliasFile ?? false {
        return try URL(resolvingAliasFileAt: url)
    }
    return url
}

