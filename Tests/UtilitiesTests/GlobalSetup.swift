import Foundation
import XCTest

class BaseTestCase: XCTestCase {
    
    static let globalSetup: Void = {
        print("\n\n\nGLOBAL SETUP\n\n\n")
        let apiKey = ProcessInfo.processInfo.environment["API_KEY"]
        print("apiKey: \(apiKey ?? "nil")\n\n\n")
    }()

    override class func setUp() {
        _ = Self.globalSetup
    }

}
