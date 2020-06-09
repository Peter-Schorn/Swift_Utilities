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
        
        
    }
    
    func testCannonicalPath() {
        
        let warning = (
            "WARNING: Can't perform test method 'testCannonicalPath' on macOS < 10.15",
            "-".multiplied(by: 58) + "\n" + "-".multiplied(by: 58)
        )
        
        if #available(macOS 10.15, *) {
        
        #if os(macOS)
        let path = URL(fileURLWithPath: "/var/folders/")
        do {
            if let cannonical = try path.cannonicalPath() {
                XCTAssertEqual(cannonical.path, "/private/var/folders")
            }
        
        } catch {
            XCTFail("\(error)")
        }
        #else
        #warning("Can't perform test method 'testCannonicalPath' on non-macOS system")
        #endif
        
        }
        else {
            paddedPrint(warning.0, padding: warning.1)
        }
        
    }
    
    func testURLResolveAlias() {
        
        
        
        #if os(macOS)
        let aliasPath = URL(fileURLWithPath: "/var")
        
        do {
            let originalPath = try resolveAlias(at: aliasPath)
            XCTAssertEqual(originalPath.path, "/private/var")
            
        } catch {
            XCTFail("\(error)")
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
