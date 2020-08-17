import Foundation

public extension UserDefaults {
    
    struct Key: RawRepresentable, Equatable, Hashable {

        public typealias RawValue = String

        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
    }
    
    // MARK: - Getters
    
    /// Returns the object associated with the specified key.
    func object(forKey key: Key) -> Any? {
        return self.object(forKey: key.rawValue)
    }
    
    /// Returns the URL associated with the specified key.
    func url(forKey key: Key) -> URL? {
        return self.url(forKey: key.rawValue)
    }
    
    /// Returns the array associated with the specified key.
    func array(forKey key: Key) -> [Any]? {
        return self.array(forKey: key.rawValue)
    }
    
    /// Returns the dictionary object associated with the specified key.
    func dictionary(forKey key: Key) -> [String : Any]? {
        return self.dictionary(forKey: key.rawValue)
    }
    
    /// Returns the string associated with the specified key.
    func string(forKey key: Key) -> String? {
        return self.string(forKey: key.rawValue)
    }
    
    /// Returns the array of strings associated with the specified key.
    func stringArray(forKey key: Key) -> [String]? {
        return self.stringArray(forKey: key.rawValue)
    }
    
    /// Returns the data object associated with the specified key.
    func data(forKey key: Key) -> Data? {
        return self.data(forKey: key.rawValue)
    }
    
    /// Returns the Boolean value associated with the specified key.
    func bool(forKey key: Key) -> Bool {
        return self.bool(forKey: key.rawValue)
    }
    
    /// Returns the integer value associated with the specified key.
    func integer(forKey key: Key) -> Int {
        return self.integer(forKey: key.rawValue)
    }
    
    /// Returns the float value associated with the specified key.
    func float(forKey key: Key) -> Float {
        return self.float(forKey: key.rawValue)
    }
    
    /// Returns the double value associated with the specified key.
    func double(forKey key: Key) -> Double {
        return self.double(forKey: key.rawValue)
    }
    
    // MARK: - Setters
    
    /// Sets the value of the specified default key.
    func set(_ value: Any?, forKey key: Key) {
        self.set(value, forKey: key.rawValue)
    }
    
    /// Sets the value of the specified default key to the specified float value.
    func set(_ value: Float, forKey key: Key) {
        self.set(value, forKey: key.rawValue)
    }
    
    /// Sets the value of the specified default key to the double value.
    func set(_ value: Double, forKey key: Key) {
        self.set(value, forKey: key.rawValue)
    }
    
    /// Sets the value of the specified default key to the specified integer value.
    func set(_ value: Int, forKey key: Key) {
        self.set(value, forKey: key.rawValue)
    }
    
    /// Sets the value of the specified default key to the specified Boolean value.
    func set(_ value: Bool, forKey key: Key) {
        self.set(value, forKey: key.rawValue)
    }
    
    /// Sets the value of the specified default key to the specified URL.
    func set(_ value: URL, forKey key: Key) {
        self.set(value, forKey: key.rawValue)
    }

    // MARK: - removeObject
    
    /// Removes the value of the specified default key.
    func removeObject(forKey key: Key) {
        self.removeObject(forKey: key.rawValue)
    }
    
    // MARK: Codable
    
    /**
     Finds the data for the specified key and trys to decode it into
     the specified type.
    
     - Parameters:
       - type: The type to decode the data into. Must conform
             to `Decodable`.
       - key: A key in the current user‘s defaults database.
       - decoder: The JSONDecoder to use to decode the data.
             Defaults to a new instance.
     - Returns: An instance of the indicated type
           or `nil` if data for the specified key cannot be found.
     - Throws: If the json decoder throws an error when decoding
           the data.
     */
    func decode<T: Decodable>(
        _ type: T.Type, forKey key: Key, decoder: JSONDecoder = .init()
    ) throws -> T? {
        
        guard let data = self.data(forKey: key) else {
            return nil
        }
        return try decoder.decode(type, from: data)
        
    }
    
    /**
     Encodes the specified object into data and saves it for
     the specified key.
     
     - Parameters:
       - object: The object that will be encoded into data and
             stored in the database. Must conform to `Encodable`.
       - key: A key in the current user‘s defaults database.
       - encoder: The JSONEncoder to use to encode the object.
             Defaults to a new instance.
     
     - Throws: If the json encoder throws an error when encoding
           the object.
     */
    func encode<T: Encodable>(
        _ object: T, forKey key: Key, encoder: JSONEncoder = .init()
    ) throws {
        let data = try encoder.encode(object)
        self.set(data, forKey: key)
    }
    
}
