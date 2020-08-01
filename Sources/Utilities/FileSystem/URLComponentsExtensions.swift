import Foundation

public extension URLComponents {
    
    init(
        scheme: String? = "https",
        host: String? = nil,
        path: String,
        queryItems: [URLQueryItem]? = nil
    ) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
    
}
