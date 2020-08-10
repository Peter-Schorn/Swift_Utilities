import Foundation

public extension URLComponents {
    
    init(
        scheme: String?,
        host: String?,
        path: String? = nil,
        queryItems: [String: String]? = nil,
        fragment: String? = nil
    ) {
        let urlQueryItems = queryItems?.map { item in
            URLQueryItem(name: item.key, value: item.value)
        }
        
        self.init(
            scheme: scheme,
            host: host,
            path: path,
            queryItems: urlQueryItems,
            fragment: fragment
        )
    }
    
    
    init(
        scheme: String?,
        host: String?,
        path: String? = nil,
        queryItems: [URLQueryItem]?,
        fragment: String? = nil
    ) {
        self.init()
        self.scheme = scheme
        self.host = host
        if let path = path {
            self.path = path
        }
        self.queryItems = queryItems
        self.fragment = fragment
    }
    
    
    /// A dictionary of the query items in the url components.
    var queryItemsDict: [String: String]? {
        
        return self.queryItems?.reduce(into: [:]) { dict, query in
            dict[query.name] = query.value
        }
    }
    
}
