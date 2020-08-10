import Foundation

public extension Bundle {
    
    /**
     Loads Json data from bundle.
     - Parameters:
       - file: File name excluding extension.
       - ext: The extension of the file.
       - type: The type that the json will be converted to.
       - decoder: The JSONDecoder to use. Defaults to a new instance.
     - Returns: The object initialized according to the specified type.
     
     Example:
     ```
     let menu = Bundle.main.decode("menu.json", into: [String].self)
     ```
     `menu` is now an array of strings loaded from the Json file.
     */
    func decode<T: Decodable>(
        _ file: String,
        extension: String? = nil,
        type: T.Type,
        decoder: JSONDecoder = .init()
    ) -> T {
        
        guard let url = self.url(
            forResource: file, withExtension: `extension`
        ) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return decodedData
    }
}


/// Loads json from a file.
public func loadJSONFromFile<T: Decodable>(
    url: URL,
    type: T.Type,
    decoder: JSONDecoder = .init()
) throws -> T {
    
    let data = try Data(contentsOf: url)
    
    let loadedData = try decoder.decode(T.self, from: data)
    
    return loadedData
}

/// Saves json to a file.
public func saveJSONToFile<T: Encodable>(
    url: URL, data: T, encoder: JSONEncoder = .init()
) throws {
    
    let data = try encoder.encode(data)
    try data.write(to: url)
    
}
