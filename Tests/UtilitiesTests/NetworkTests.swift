import Foundation
import Utilities
import XCTest


class NetworkTests: XCTestCase {
    
    static var allTests = [
        ("testURLRequestDecodeJSON", testURLRequestDecodeJSON)
    ]
    
    var asyncExpectation: XCTestExpectation!
    
    func testURLRequestDecodeJSON() {
        
        print("called testURLRequestDecodeJSON")
        
        let endpoint = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        struct DogResponse: Codable {
            
            let message: String
            let status: String

        }

        asyncExpectation = expectation(description: "need url response from dog API")
        URLSession.shared.decodeJSON(
            url: endpoint,
            responseObject: DogResponse.self
        ) { result in
            
            defer { self.asyncExpectation.fulfill() }
            
            self.assertNoThrow("error when trying to get JSON from dog api") {
                
                let dogResponse = try result.get()
                print("got json response from dog api:")
                print(dogResponse.status)
                print(dogResponse.message, terminator: "\n\n")
                XCTAssertEqual(dogResponse.status, "success")
            }
            

        }
        
        waitForExpectations(timeout: 30) { error in
            
            if let error = error {
                XCTFail("\(error)")
            }
            
        }
        
        
    }


}
