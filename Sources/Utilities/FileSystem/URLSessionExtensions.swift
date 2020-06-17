import Foundation


extension URLSession {
    
    /**
     Wraps around the function with the same name
     and transforms the completion hander into a Result.
     
     Transforms the completion handler from
     ```
     @escaping (Data?, URLResponse?, Error?) -> Void
     ```
     into
     ```
     @escaping Result<(data: Data, urlResponse: URLResponse), Error>
     ```
     */
    public func dataTask(
        with url: URL,
        completionHandler: @escaping (
            Result<(data: Data, urlResponse: URLResponse), Error>
        ) -> Void
    ) -> URLSessionDataTask {
        
        return self.dataTask(with: url) { data, response, error in
            assert(
                !(data == nil && error == nil),
                "dataTask: Both data and error were nil"
            )
            assert(
                !(data != nil && error != nil),
                "dataTask: Both data and error were NON-nil"
            )
            
            if let data = data {
                completionHandler(.success((data: data, urlResponse: response!)))
            }
            else {
                completionHandler(.failure(error ?? NSError()))
            }
            
        }
        
    }
    
    /**
    Wraps around the function with the same name
    and transforms the completion hander into a Result.
    
    Transforms the completion handler from
    ```
    @escaping (Data?, URLResponse?, Error?) -> Void
    ```
    into
    ```
    @escaping Result<(data: Data, urlResponse: URLResponse), Error>
    ```
    */
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (
            Result<(data: Data, urlResponse: URLResponse), Error>
        ) -> Void
    ) -> URLSessionDataTask {
        
        return self.dataTask(with: request) { data, response, error in
            assert(
                !(data == nil && error == nil),
                "dataTask: Both data and error were nil"
            )
            assert(
                !(data != nil && error != nil),
                "dataTask: Both data and error were NON-nil"
            )
            
            if let data = data {
                completionHandler(.success((data: data, urlResponse: response!)))
            }
            else {
                completionHandler(.failure(error ?? NSError()))
            }
            
        }
        
    }
    
    
    
    public typealias DetermineResponseObject<ResponseObject: Decodable> =
            (_ httpStatusCode: Int) -> (ResponseObject.Type, decoder: JSONDecoder)
    
    public typealias DecodeJSONCompletion<ResponseObject: Decodable> =
            (Result<ResponseObject, Error>) -> Void
    

    private func decodeJSONCompletionWrapper<
        ResponseObject: Decodable
    >(
        determineResponseObject: @escaping DetermineResponseObject<ResponseObject>,
        completion: @escaping DecodeJSONCompletion<ResponseObject>
    ) -> ((Result<(data: Data, urlResponse: URLResponse), Error>) -> Void) {
        
        return { result in
            
            do {
                let (data, urlResponse) = try result.get()
                let httpResponse = urlResponse as! HTTPURLResponse
                
                let (responseType, decoder) = determineResponseObject(
                    httpResponse.statusCode
                )
                let responseObject = try decoder.decode(responseType, from: data)
                
                completion(.success(responseObject))
                
            } catch {
                completion(.failure(error))
            }

        }
        
    }

    /**
     Retrieves JSON data from a URL and decodes it into a `Decodable` type.
     
     `ResponseObject` represents the Decodable type that
     the json data will be decoded into.
     
     Note that there is a convienence method that accepts a single response object
     instead of a closure that determines the response object.
     
     - Parameters:
       - url: The URL of the resource.
       - determineResponseObject:
             A closure that accepts the http status code (Int)
             from the server and uses it to determine which JSON object to decode
             the data into, and which JSONDecoder to use.
             This is useful because servers often return a different
             json object upon encountering an error.
       - completion: Called when the request has been completed. Accepts a single
             `Result<ResponseObject, Error>` parameter and returns Void.
     - Returns: The url session data task.
 
     - Warning: The URLResponse will be **force-downcasted** into HTTPURLResponse.
           Therefore, do not use this method if you are not making a http request.
     */
    @discardableResult
    public func decodeJSON<
        ResponseObject: Decodable
    >(
        url: URL,
        determineResponseObject: @escaping DetermineResponseObject<ResponseObject>,
        completion: @escaping DecodeJSONCompletion<ResponseObject>
    ) -> URLSessionDataTask {
    
        let task = URLSession.shared.dataTask(
            with: url,
            completionHandler: decodeJSONCompletionWrapper(
                determineResponseObject: determineResponseObject,
                completion: completion
            )
        )
        
        task.resume()
        return task
        
    }
    
    /**
     Retrieves JSON data from a URL and decodes it into a `Decodable` type.
     
     - Parameters:
       - url: The URL of the resource.
       - responseObject: The Decodable type that the json data will
             be decoded into.
       - jsonDecoder: The json decoder to use when decoding the object.
             Defaults to a new instance.
       - completion: Called when the request has been completed. Accepts a single
             `Result<ResponseObject, Error>` parameter and returns Void.
     - Returns: The url session data task.

     - Warning: The URLResponse will be **force-downcasted** into HTTPURLResponse.
           Therefore, do not use this method if you are not making a http request.
     */
    @discardableResult
    public func decodeJSON<
        ResponseObject: Decodable
    >(
        url: URL,
        responseObject: ResponseObject.Type,
        jsonDecoder: JSONDecoder = .init(),
        completion: @escaping DecodeJSONCompletion<ResponseObject>
    ) -> URLSessionDataTask {
     
        return self.decodeJSON(
            url: url,
            determineResponseObject: { _ in
                (responseObject, decoder: jsonDecoder)
            },
            completion: completion
        )
        
    }

    
    /**
     Retrieves JSON data from a URL and decodes it into a `Decodable` type.
     
     `ResponseObject` represents the Decodable type that
     the json data will be decoded into.
     
     Note that there is a convienence method that accepts a single response object
     instead of a closure that determines the response object.
     
     - Parameters:
         - request: A URL request.
         - determineResponseObject:
             A closure that accepts the http status code (Int)
             from the server and uses it to determine which JSON object to decode
             the data into, and which JSONDecoder to use.
             This is useful because servers often return a different
             json object upon encountering an error.
         - completion: Called when the request has been completed. Accepts a single
             `Result<ResponseObject, Error>` parameter and returns Void.
     - Returns: The url session data task.
    
     - Warning: The URLResponse will be **force-downcasted** into HTTPURLResponse.
             Therefore, do not use this method if you are not making a http request.
     */
    @discardableResult
    public func decodeJSON<
        ResponseObject: Decodable
    >(
        request: URLRequest,
        determineResponseObject: @escaping DetermineResponseObject<ResponseObject>,
        completion: @escaping DecodeJSONCompletion<ResponseObject>
    ) -> URLSessionDataTask {
    
        let task = URLSession.shared.dataTask(
            with: request,
            completionHandler: decodeJSONCompletionWrapper(
                determineResponseObject: determineResponseObject,
                completion: completion
            )
        )
        
        task.resume()
        return task
        
    }
    
    /**
    Retrieves JSON data from a URL and decodes it into a `Decodable` type.
    
     - Parameters:
       - request: A URL request.
       - responseObject: The Decodable type that the json data will
             be decoded into.
       - jsonDecoder: The json decoder to use when decoding the object.
             Defaults to a new instance.
       - completion: Called when the request has been completed. Accepts a single
             `Result<ResponseObject, Error>` parameter and returns Void.
     - Returns: The url session data task.

     - Warning: The URLResponse will be **force-downcasted** into HTTPURLResponse.
           Therefore, do not use this method if you are not making a http request.
    */
    @discardableResult
    public func decodeJSON<
        ResponseObject: Decodable
    >(
        request: URLRequest,
        responseObject: ResponseObject.Type,
        jsonDecoder: JSONDecoder = .init(),
        completion: @escaping DecodeJSONCompletion<ResponseObject>
    ) -> URLSessionDataTask {
     
        return self.decodeJSON(
            request: request,
            determineResponseObject: { _ in
                (responseObject, decoder: jsonDecoder)
            },
            completion: completion
        )
        
    }

    /**
     Sends json data to a url and decodes the response into a `Decodable` type.
     
     `ResponseObject` represents the Decodable type that
     the json data will be decoded into.
     
     Note that there is a convienence method that accepts a single response object
     instead of a closure that determines the response object.
     
     - Parameters:
       - url: The URL of the resource.
       - httpMethod: The http method. ("GET", "POST", "DELETE", etc.)
       - headers: The http headers. The default values are usually sufficient.
       - httpBody: The body of the http request.
       - httpBodyEncoder: The json encoder used to encode the body.
             Defaults to a new instance.
       - determineResponseObject: A closure that accepts the http status code (Int)
             from the server and uses it to determine which JSON object to decode
             the data into, and which JSONDecoder to use.
             This is useful because servers often return a different
             json object upon encountering an error.
       - completion: Called when the request has been completed. Accepts a single
           `Result<ResponseObject, Error>` parameter and returns Void.
     - Returns: The url session data task.
     
     - Warning: The URLResponse will be **force-downcasted** into HTTPURLResponse.
           Therefore, do not use this method if you are not making a http request.
     */
    @discardableResult
    public func decodeJSONWithBody<
        Body: Encodable, ResponseObject: Decodable
    >(
        url: URL,
        httpMethod: String,
        headers: [(headerField: String, value: String)] = [
            (headerField: "Accept", value: "application/json"),
            (headerField: "Content-Type", value: "application/json"),
        ],
        httpBody: Body,
        httpBodyEncoder: JSONEncoder = .init(),
        determineResponseObject: @escaping DetermineResponseObject<ResponseObject>,
        completion: @escaping (Result<ResponseObject, Error>) -> Void
    ) -> URLSessionDataTask? {
    
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        for header in headers {
            request.addValue(
                header.value,
                forHTTPHeaderField: header.headerField
            )
        }
        
        do {
            request.httpBody = try httpBodyEncoder.encode(httpBody)
            
        } catch {
            completion(.failure(error))
            return nil
        }
        
        let task = URLSession.shared.dataTask(
            with: request,
            completionHandler: decodeJSONCompletionWrapper(
                determineResponseObject: determineResponseObject,
                completion: completion
            )
        )
        
        task.resume()
        return task

    }

    
    /**
     Sends json data to a url and decodes the response into a `Decodable` type.
     
     `ResponseObject` represents the Decodable type that
     the json data will be decoded into.
     
     - Parameters:
       - url: The URL of the resource.
       - httpMethod: The http method. ("GET", "POST", "DELETE", etc.)
       - headers: The http headers. The default values are usually sufficient.
       - httpBody: The body of the http request.
       - httpBodyEncoder: The json encoder used to encode the body.
             Defaults to a new instance.
       - responseObject: The Decodable type that the json data will
             be decoded into.
       - jsonDecoder: The json decoder to use when decoding the response object.
             Defaults to a new instance.
       - completion: Called when the request has been completed. Accepts a single
           `Result<ResponseObject, Error>` parameter and returns Void.
     - Returns: The url session data task.
     
     - Warning: The URLResponse will be **force-downcasted** into HTTPURLResponse.
           Therefore, do not use this method if you are not making a http request.
     */
    @discardableResult
    public func decodeJSONWithBody<
        Body: Encodable, ResponseObject: Decodable
    >(
        url: URL,
        httpMethod: String,
        headers: [(headerField: String, value: String)] = [
            (headerField: "Accept", value: "application/json"),
            (headerField: "Content-Type", value: "application/json"),
        ],
        httpBody: Body,
        httpBodyEncoder: JSONEncoder = .init(),
        responseObject: ResponseObject.Type,
        jsonDecoder: JSONDecoder = .init(),
        completion: @escaping (Result<ResponseObject, Error>) -> Void
    ) -> URLSessionDataTask? {
     
        return self.decodeJSONWithBody(
            url: url,
            httpMethod: httpMethod,
            httpBody: httpBody,
            determineResponseObject: { _ in
                (responseObject, decoder: jsonDecoder )
            },
            completion: completion
        )
    
        
    }

    
}
