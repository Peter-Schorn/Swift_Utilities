import Foundation
import XCTest
import Utilities


class FileAndURLTests: BaseTestCase {

    static var allTests = [
        ("testShellScripting", testShellScripting),
        ("testCannonicalPath", testCannonicalPath),
        ("testURLLastPathName", testURLLastPathName),
        ("testURLResolveAlias", testURLResolveAlias),
        ("testAppendQueryItemToURL", testAppendQueryItemToURL),
    ]
    
    
    func testShellScripting() throws {
        
        #if os(macOS)
        if #available(macOS 10.13, *) {
            
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
                padding: String(repeating: "-", count: 58) +
                    "\n" + String(repeating: "-", count: 58)
            )
        }
        
        #else
        #warning("Can't perform test method 'testShellScripting' on non-macOS system")
        #endif
        
    }
    
    func testCannonicalPath() throws {
        
        #if os(macOS)
        if #available(macOS 10.15, *) {
            
            let path = URL(fileURLWithPath: "/var/folders/")
            if let cannonical = try path.canonicalPath() {
                XCTAssertEqual(cannonical.path, "/private/var/folders")
            }
            
        }
        else {
            paddedPrint(
                "WARNING: Can't perform test method 'testCannonicalPath' on macOS < 10.15",
                padding: String(repeating: "-", count: 58) +
                "\n" + String(repeating: "-", count: 58)
            )
        }
        #else
        #warning("Can't perform test method 'testCannonicalPath' on non-macOS system")
        #endif
        
    }
    
    func testURLResolveAlias() throws {
        
        
        
        #if os(macOS)
        let aliasPath = URL(fileURLWithPath: "/var")
        
        let originalPath = try resolveAlias(at: aliasPath)
        XCTAssertEqual(originalPath.path, "/private/var")
        
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
        
        XCTFail("intentional failure")

        if var endpoint = URL(string: "https://api.themoviedb.org/0/account/movies") {
            
            endpoint.append(
                queryItems: [URLQueryItem(name: "page space", value: "5")]
            )
            
            XCTAssertEqual(
                endpoint.absoluteString,
                "https://api.themoviedb.org/0/account/movies?page%20space=5"
            )
            endpoint.append(
                queryItems: [URLQueryItem(name: "language", value: "english")]
            )
            
            XCTAssertEqual(
                endpoint.absoluteString,
                "https://api.themoviedb.org/0/account/movies?page%20space=5&language=english"
            )
            
        }
        else {
            XCTFail("should've gotten url from string")
        }

        
        
    }
    
    
    
    
    
    
    

}
