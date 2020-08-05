import Foundation

public extension URLComponents {
    
    init(
        scheme: String? = "https",
        host: String? = nil,
        path: String? = nil,
        queryItems: [String: String]? = nil
    ) {
        
        let urlQueryItems = queryItems?.map { item in
            URLQueryItem(name: item.key, value: item.value)
        }
        
        self.init(
            scheme: scheme,
            host: host,
            path: path,
            queryItems: urlQueryItems
        )
        
    }
    
    init(
        scheme: String? = "https",
        host: String? = nil,
        path: String? = nil,
        queryItems: [URLQueryItem]?
    ) {
        self.init()
        self.init()
        self.scheme = scheme
        if let host = host {
            self.host = host
        }
        if let path = path {
            self.path = path
        }
        if let queryItems = queryItems {
            self.queryItems = queryItems
        }
    }
    
}
