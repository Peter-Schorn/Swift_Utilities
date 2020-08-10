import Foundation


public extension URL {

    /// Returns a new url with the specified query items appended to it.
    func appending(queryItems: [URLQueryItem]) -> URL? {

        guard var urlComponents = URLComponents(
            url: self, resolvingAgainstBaseURL: false
        ) else {
            return nil
        }

        var currentQueryItems = urlComponents.queryItems ??  []

        currentQueryItems.append(contentsOf: queryItems)

        urlComponents.queryItems = currentQueryItems

        return urlComponents.url
    }
    
    /// Returns a new url with the specified query items appended to it.
    func appending(queryItems: [String: String]) -> URL? {
        
        let urlQueryItems = queryItems.map { item in
            URLQueryItem(name: item.key, value: item.value)
        }
        return self.appending(queryItems: urlQueryItems)
    
    }
    
    /// Appends the query items to the url.
    mutating func append(queryItems: [URLQueryItem]) {
        guard let url = self.appending(queryItems: queryItems) else {
            fatalError(
                """
                could not construct new url after appending query items.
                original url: '\(self)'
                queryItems: '\(queryItems)'
                """
            )
        }
        self = url
    }

    /// Appends the query items to the url.
    mutating func append(queryItems: [String: String]) {
        let urlQueryItems = queryItems.map { item in
            URLQueryItem(name: item.key, value: item.value)
        }
        self.append(queryItems: urlQueryItems)
    }
    
    
    /// The last component of the path excluding the file extension.
    /// Calls self.lastPathComponent and strips all text
    /// after and including the last period.
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
        return components?.queryItems
    }

    /// A dictionary of the query items in the url.
    var queryItemsDict: [String: String]? {
        
        return self.queryItems?.reduce(into: [:]) { dict, query in
            dict[query.name] = query.value
        }
    }
    
    /// The url components of this url.
    var components: URLComponents? {
        return URLComponents(
            url: self, resolvingAgainstBaseURL: false
        )
    }
    
    
    init?(
        scheme: String?,
        host: String?,
        path: String? = nil,
        queryItems: [String: String]? = nil
    ) {
    
        if let url = URLComponents(
            scheme: scheme,
            host: host,
            path: path,
            queryItems: queryItems
        ).url {
            self = url
        }
        else {
            return nil
        }
        
    }
        
    init?(
        scheme: String?,
        host: String?,
        path: String? = nil,
        queryItems: [URLQueryItem]?,
        fragment: String? = nil
    ) {
        
        if let url = URLComponents(
            scheme: scheme,
            host: host,
            path: path,
            queryItems: queryItems,
            fragment: fragment
        ).url {
            self = url
        }
        else {
            return nil
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


/// Encodes a dictionary into data according to
/// `application/x-www-form-urlencoded`.
///
/// Returns `nil` if the query string cannot be converted to
/// `Data` using a utf-8 character encoding.
public func formURLEncode(_ dict: [String: String]) -> Data? {
    
    var urlComponents = URLComponents()
    urlComponents.queryItems = dict.map { item in
        URLQueryItem(name: item.key, value: item.value)
    }
    return urlComponents.query?.data(using: .utf8)
}
