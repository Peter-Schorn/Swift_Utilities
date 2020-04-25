//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/17/20.
//

import Foundation



public extension Bundle {
    
    /**
     Loads Json data from bundle.
     - Parameters:
       - file: File name excluding extension
       - ext: The extension of the file
       - type: The type that the json will be converted to
     - Returns: The object initialized according to the specified type
     
     Example:
     ```
     let menu = Bundle.main.decode("menu.json", [String].self)
     ```
     `menu` is now an array of strings loaded from the Json file
     */
    func decode<T: Decodable>(_ file: String, ext: String? = nil, type: T.Type) -> T {
        
        guard let url = self.url(forResource: file, withExtension: ext) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}


/**
 Loads Json data from an external file path
 
 Example:
 ```
 let git_repos = LoadJson(
    file: "/Users/john/Desktop/git_repos.json",
    type: [String].self
 )
 ```
 `git_repos` is now an array of strings loaded from the Json file
 */
public func loadJson<T: Decodable>(
    file: URL,
    encoding: String.Encoding = .utf8,
    type typ: T.Type
) -> T {
    
    guard let rawText = try? String(contentsOf: file, encoding: encoding) else {
        fatalError("Failed to find file at \(file)")
    }
    
    guard let jsonData = rawText.data(using: encoding) else {
        fatalError("Failed to load data from \(file)")
    }
    
    guard let loadedData = try? JSONDecoder().decode(T.self, from: jsonData) else {
        fatalError("failed to decode json data from \(file)")
    }
    
    return loadedData
}
