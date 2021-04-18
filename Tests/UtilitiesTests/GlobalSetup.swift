import Foundation
import XCTest

class BaseTestCase: XCTestCase {
    
    static let globalSetup: Void = {
        print("\n\n\nGLOBAL SETUP\n")
        let apiKey = ProcessInfo.processInfo.environment["API_KEY"]
        XCTAssertNotNil(apiKey, "API_KEY was nil")
        if let key = apiKey {
            let scramlbedKey = key.joined(separator: " ")
            print("scambled key: \(scramlbedKey)")
        }
        print("\n\n\n")
    }()
    
    override class func setUp() {
        _ = Self.globalSetup
    }

}
