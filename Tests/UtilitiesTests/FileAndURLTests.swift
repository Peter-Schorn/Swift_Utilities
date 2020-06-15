import Foundation
import XCTest
import Utilities


class FileAndURLTests: XCTestCase {

    static var allTests = [
        ("testShellScripting", testShellScripting),
        ("testCannonicalPath", testCannonicalPath),
        ("testURLLastPathName", testURLLastPathName),
        ("testURLResolveAlias", testURLResolveAlias),
        ("testAppendQueryItemToURL", testAppendQueryItemToURL),
    ]
    
    
    func testShellScripting() {
        
        if #available(OSX 10.13, *) {
            
            runShellScriptAsync(args: ["echo", "hello"]) { process, stdout, stderror in
                XCTAssertEqual(stdout, Optional("hello"))
                XCTAssertEqual(stderror, Optional(""))
                XCTAssertEqual(process.terminationStatus, 0)
            }
            let output = runShellScript(args: ["echo", "hello"])
            XCTAssertEqual(output.stdout, Optional("hello"))
            XCTAssertEqual(output.stderror, Optional(""))
            XCTAssertEqual(output.process.terminationStatus, 0)
            
            
            runShellScriptAsync(args: ["echo", "hello"]) { process, stdout, stderror in
                XCTAssertEqual(stdout, Optional("hello"))
                XCTAssertEqual(stderror, Optional(""))
                XCTAssertEqual(process.terminationStatus, 0)
                
            }
            
        } else {
            paddedPrint(
                "WARNING: Can't perform test method 'testShellScripting' on macOS < 10.13",
                padding: "-".multiplied(by: 58) + "\n" + "-".multiplied(by: 58)
            )
        }
        
        
    }
    
    func testCannonicalPath() {
        
        #if os(macOS)

        if #available(macOS 10.15, *) {
        
        let path = URL(fileURLWithPath: "/var/folders/")
        assertNoThrow {
            if let cannonical = try path.cannonicalPath() {
                XCTAssertEqual(cannonical.path, "/private/var/folders")
            }
        
        }
        
        }
        else {
            paddedPrint(
                "WARNING: Can't perform test method 'testCannonicalPath' on macOS < 10.15",
                padding: "-".multiplied(by: 58) + "\n" + "-".multiplied(by: 58)
            )
        }
        #else
        #warning("Can't perform test method 'testCannonicalPath' on non-macOS system")
        #endif
        
    }
    
    func testURLResolveAlias() {
        
        
        
        #if os(macOS)
        let aliasPath = URL(fileURLWithPath: "/var")
        
        assertNoThrow {
            let originalPath = try resolveAlias(at: aliasPath)
            XCTAssertEqual(originalPath.path, "/private/var")
            
        }
        #else
        #warning("cannot perform test method 'testURLResolveAlias' on non-macOS system")
        #endif
    }
    
    
    func testURLLastPathName() {
        
        let myFile = URL(
            fileURLWithPath: "/Users/pschorn/Swift/Libraries/Swift_Utilities/Package.swift"
        )
        
        XCTAssertEqual(myFile.lastPathName, "Package")
        
        
    }
    
    
    func testAppendQueryItemToURL() {
        
        if var endpoint = URL(string: "https://api.themoviedb.org/0/account/movies") {
            
            endpoint.append(URLQueryItem(name: "page space", value: "5"))
            
            XCTAssertEqual(
                endpoint.absoluteString,
                "https://api.themoviedb.org/0/account/movies?page%20space=5"
            )
            endpoint.append(URLQueryItem(name: "language", value: "english"))
            
            XCTAssertEqual(
                endpoint.absoluteString,
                "https://api.themoviedb.org/0/account/movies?page%20space=5&language=english"
            )
            
        }
        else {
            XCTFail("should've gotten url from string")
        }

        
        if var endpoint = URL(
            string: "https://developers.themoviedb.org/3/account/get-movie-watchlist"
        ) {
            
            endpoint.append(page: 5)
            XCTAssertEqual(
                endpoint.absoluteString,
                "https://developers.themoviedb.org/3/account/get-movie-watchlist?page=5"
            )
            
        }
        else {
            XCTFail("should've gotten url from string")
        }
        
        
    }
    
    
    
    
    
    
    

}
