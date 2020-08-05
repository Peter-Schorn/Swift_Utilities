import Foundation


extension URLSession {
    
    // MARK: - Completion Wrapper
    private func decodeJSONCompletionWrapper<
        ResponseObject: CustomDecodable,
        ErrorResponseObject: CustomDecodable & Error
    >(
        responseObject: ResponseObject.Type,
        errorResponseObject: ErrorResponseObject.Type?,
        completion: @escaping (Result<ResponseObject, Error>) -> Void
    ) -> (Data?, URLResponse?, Error?) -> Void {
        
        return { data, urlResponse, error in
            
            guard let data = data else {
                completion(.failure(error ?? NSError()))
                return
            }
            
            do {
                let response = try responseObject.decoded(from: data)
                completion(.success(response))
                
            } catch {
                if let errorResponseObject = errorResponseObject {
                    do {
                        let errorResponse = try errorResponseObject
                            .decoded(from: data)
                        completion(.failure(errorResponse))
                        
                    } catch {
                        completion(.failure(error))
                    }
                }
                else {
                    completion(.failure(error))
                }
            }

        }
        
    }

    
    // MARK: - Decode JSON with URLRequest
    
    /**
     Retrieves JSON data from a `URLRequest`
     and decodes it into a `Decodable` type.
     
     - Parameters:
       - request: A URL request.
       - responseObject: The Decodable type that the json data will
             be decoded into.
       - errorResponseObject: If decoding into the responseObject fails,
             then this method attempts to decode the data into this object.
             If decoding the data into this object succeeds, then it
             will be passed in as an **error** in the completion handler.
       - completion: Called when the request has been completed.
              Accepts a single `Result<ResponseObject, Error>`
              parameter and returns Void.
     - Returns: The url session data task.
    */
    @discardableResult
    public func decodeJSON<
        ResponseObject: CustomDecodable,
        ErrorResponseObject: CustomDecodable & Error
    >(
        request: URLRequest,
        responseObject: ResponseObject.Type,
        errorResponseObject: ErrorResponseObject.Type?,
        completion: @escaping (Result<ResponseObject, Error>) -> Void
    ) -> URLSessionDataTask {
     
        let task = URLSession.shared.dataTask(
            with: request,
            completionHandler: decodeJSONCompletionWrapper(
                responseObject: responseObject,
                errorResponseObject: errorResponseObject,
                completion: completion
            )
        )
        task.resume()
        return task
    }
    
    
    /**
     Retrieves JSON data from a `URLRequest`
     and decodes it into a `Decodable` type.
     
     - Parameters:
       - request: A URL request.
       - responseObject: The Decodable type that the json data will
             be decoded into.
       - completion: Called when the request has been completed.
              Accepts a single `Result<ResponseObject, Error>`
              parameter and returns Void.
     - Returns: The url session data task.
    */
    @discardableResult
    public func decodeJSON<
        ResponseObject: CustomDecodable
    >(
        request: URLRequest,
        responseObject: ResponseObject.Type,
        completion: @escaping (Result<ResponseObject, Error>) -> Void
    ) -> URLSessionDataTask {
     
        return self.decodeJSON(
            request: request,
            responseObject: responseObject,
            errorResponseObject: nil as GenericError.Type?,
            completion: completion
        )
        
    }

    // MARK: - Decode JSON with URL and Body
    
    /**
     Sends json data to a url and decodes the response
     into a `Decodable` type.
     
     `ResponseObject` represents the Decodable type that
     the json data will be decoded into.
     
     - Parameters:
       - url: The URL of the resource.
       - httpMethod: The http method. ("GET", "POST", "DELETE", etc.)
       - headers: The http headers. The default values are usually sufficient.
       - httpBody: The body of the http request.
       - responseObject: The Decodable type that the json data will
             be decoded into.
       - errorResponseObject: If decoding into the responseObject fails,
             then this method attempts to decode the data into this object.
             If decoding the data into this object succeeds, then it
             will be passed in as an **error** in the completion handler.
       - completion: Called when the request has been completed.
             Accepts a single `Result<ResponseObject, Error>`
             parameter and returns Void.
     - Returns: The url session data task.
     */
    @discardableResult
    public func decodeJSON<
        ResponseObject: CustomDecodable,
        ErrorResponseObject: CustomDecodable & Error
    >(
        url: URL,
        httpMethod: String,
        headers: [String: String],
        httpBody: Data,
        responseObject: ResponseObject.Type,
        errorResponseObject: ErrorResponseObject.Type?,
        completion: @escaping (Result<ResponseObject, Error>) -> Void
    ) -> URLSessionDataTask {
     
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = headers
        request.httpBody = httpBody

        return self.decodeJSON(
            request: request,
            responseObject: responseObject,
            errorResponseObject: errorResponseObject,
            completion: completion
        )
    }
    
    /**
     Sends json data to a url and decodes the response
     into a `Decodable` type.
     
     `ResponseObject` represents the Decodable type that
     the json data will be decoded into.
     
     - Parameters:
       - url: The URL of the resource.
       - httpMethod: The http method. ("GET", "POST", "DELETE", etc.)
       - headers: The http headers. The default values are usually sufficient.
       - httpBody: The body of the http request.
       - responseObject: The Decodable type that the json data will
             be decoded into.
       - completion: Called when the request has been completed.
             Accepts a single `Result<ResponseObject, Error>`
             parameter and returns Void.
     - Returns: The url session data task.
     */
    @discardableResult
    public func decodeJSON<
        ResponseObject: CustomDecodable
    >(
        url: URL,
        httpMethod: String,
        headers: [String: String],
        httpBody: Data,
        responseObject: ResponseObject.Type,
        completion: @escaping (Result<ResponseObject, Error>) -> Void
    ) -> URLSessionDataTask {
     
        return self.decodeJSON(
            url: url,
            httpMethod: httpMethod,
            headers: headers,
            httpBody: httpBody,
            responseObject: responseObject,
            errorResponseObject: nil as GenericError.Type?,
            completion: completion
        )
    }
    
    

    // MARK: - Decode JSON with just URL
    
    
    /**
     Retrieves JSON data from a `URL`
     and decodes it into a `Decodable` type.
     
     - Parameters:
       - url: A URL.
       - responseObject: The Decodable type that the json data will
             be decoded into.
       - errorResponseObject: If decoding into the responseObject fails,
             then this method attempts to decode the data into this object.
             If decoding the data into this object succeeds, then it
             will be passed in as an **error** in the completion handler.
       - completion: Called when the request has been completed.
              Accepts a single `Result<ResponseObject, Error>`
              parameter and returns Void.
     - Returns: The url session data task.
    */
    @discardableResult
    public func decodeJSON<
        ResponseObject: CustomDecodable,
        ErrorResponseObject: CustomDecodable & Error
    >(
        url: URL,
        responseObject: ResponseObject.Type,
        errorResponseObject: ErrorResponseObject.Type?,
        completion: @escaping (Result<ResponseObject, Error>) -> Void
    ) -> URLSessionDataTask {
        
        let task = dataTask(
            with: url,
            completionHandler: decodeJSONCompletionWrapper(
                responseObject: responseObject,
                errorResponseObject: errorResponseObject,
                completion: completion
            )
        )
        task.resume()
        return task
        
    }
    
    
    /**
     Retrieves JSON data from a `URL`
     and decodes it into a `Decodable` type.
     
     - Parameters:
       - url: A URL.
       - responseObject: The Decodable type that the json data will
             be decoded into.
       - completion: Called when the request has been completed.
              Accepts a single `Result<ResponseObject, Error>`
              parameter and returns Void.
     - Returns: The url session data task.
    */
    @discardableResult
    public func decodeJSON<
        ResponseObject: CustomDecodable
    >(
        url: URL,
        responseObject: ResponseObject.Type,
        completion: @escaping (Result<ResponseObject, Error>) -> Void
    ) -> URLSessionDataTask {
    
        return self.decodeJSON(
            url: url,
            responseObject: responseObject,
            errorResponseObject: nil as GenericError.Type?,
            completion: completion
        )
    
    }
    
    
    
}
