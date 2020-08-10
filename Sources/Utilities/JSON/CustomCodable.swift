import Foundation


/**
 A type that provides its own JSONDecoder for decoding itself
 from data and a type method for decoding itself from data.
 */
public protocol CustomDecodable: Decodable {
    
    static var decoder: JSONDecoder { get }
    
    static func decoded(from data: Data) throws -> Self
    
}

public extension CustomDecodable {
    
    /// The `JSONDecoder` that this type wants to be used
    /// to decode itself from data.
    static var decoder: JSONDecoder { JSONDecoder() }
    
    static func decoded(from data: Data) throws -> Self {
        return try Self.decoder.decode(Self.self, from: data)
    }
    
    
}


/**
 A type that provides its own JSONEncoder for encoding itself
 into data and a method for encoding an instance of itself into data.
 */
public protocol CustomEncodable: Encodable {
    
    /// The `JSONEncoder` that this type wants to be used
    /// to decode an instance of itself into data.
    static var encoder: JSONEncoder { get }
    
    func encoded() throws -> Data
}

public extension CustomEncodable {
    
    static var encoder: JSONEncoder { JSONEncoder() }
    
    func encoded() throws -> Data {
        return try Self.encoder.encode(self)
    }
}

public typealias CustomCodable = CustomDecodable & CustomEncodable
