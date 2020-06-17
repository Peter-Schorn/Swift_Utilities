import Foundation
import Utilities
import XCTest


class NetworkTests: XCTestCase {
    
    static var allTests = [
        ("asyncExpectation", asyncExpectation)
    ]
    
    var asyncExpectation: XCTestExpectation!
    
    func testURLRequestDecodeJSON() {
        
        print("called testURLRequestDecodeJSON")
        
        let endpoint = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        struct DogResponse: Codable {
            
            let message: String
            let status: String

        }

        asyncExpectation = expectation(description: "need json response from dog API")
        URLSession.shared.decodeJSON(
            url: endpoint,
            responseObject: DogResponse.self
        ) { result in
            
            defer { self.asyncExpectation.fulfill() }
            
            self.assertNoThrow("error when trying to get JSON from dog api") {
                
                let dogResponse = try result.get()
                XCTAssertEqual(dogResponse.status, "success")
            }
            
            print("\n\ngot json response\n")

        }
        
        waitForExpectations(timeout: 30) { error in
            
            if let error = error {
                XCTFail("\(error)")
            }
            
        }
        
        
    }


}
