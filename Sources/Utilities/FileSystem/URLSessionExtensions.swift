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

    /// Decodes json objects from a URL
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
    
    /// Decodes json objects from a URL
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

    
    /// Decodes json objects from a URL
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
    
    /// Decodes json objects from a URL
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

    @discardableResult
    public func decodeJSON<
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

    
    @discardableResult
    public func decodeJSON<
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
     
        return self.decodeJSON(
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
