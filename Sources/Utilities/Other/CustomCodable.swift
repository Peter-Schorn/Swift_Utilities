import Foundation


/// A type that provides its own method for decoding itself
/// from data rather than using a JSONDecoder.
public protocol CustomDecodable: Decodable {
    
    static func decoded(from data: Data) throws -> Self
}

public extension CustomDecodable {
    
    static func decoded(from data: Data) throws -> Self {
        return try JSONDecoder.shared.decode(Self.self, from: data)
    }
}


/// A type that provides its own method for encoding itself
/// into data rather than using a JSONEncoder.
public protocol CustomEncodable: Encodable {
    
    func encoded() throws -> Data
}

public extension CustomEncodable {
    
    func encoded() throws -> Data {
        return try JSONEncoder.shared.encode(self)
    }
}

public typealias CustomCodable = CustomDecodable & CustomEncodable


// MARK: - JSON Encoder and Decoder Extensions -

public extension JSONEncoder {
    
    /// An instance without any customization.
    static let shared = JSONEncoder()
    
    /// An instance that converts keys to snake case when encoding.
    static let convertToSnakeCase = { () -> JSONEncoder in
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    
}

public extension JSONDecoder {
    
    /// An instance without any customization.
    static let shared = JSONDecoder()
    
    /// An instance that converts keys to camel case when decoding.
    static let convertToCamelCase = { () -> JSONDecoder in
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
}

