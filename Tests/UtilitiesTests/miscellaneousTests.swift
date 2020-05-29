import Foundation
import XCTest
import Utilities


extension UtilitiesTests {

    func testOperators() {
        
        XCTAssert(1 ≤ 2)
        XCTAssert(1 ≤ 1)
        XCTAssert(2 ≥ 1)
        XCTAssert(2 ≥ 2)
        
        XCTAssert(5 ** 2 == 25)  // Ints
        XCTAssert(5.0 ** 2.0 == 25.0)  // Doubles
        
        var x = 10
        x **= 2
        XCTAssertEqual(x, 100)
                
    }


    func testShellScripting() {
                
        runShellScriptAsync(args: ["echo", "hello"]) { process, stdout, stderror in
            XCTAssert(stdout == Optional("hello"))
            XCTAssert(stderror == Optional(""))
            XCTAssert(process.terminationStatus == 0)
        }
        
        let output = runShellScript(args: ["echo", "hello"])
        XCTAssert(output.stdout == Optional("hello"))
        XCTAssert(output.stderror == Optional(""))
        XCTAssert(output.process.terminationStatus == 0)
        
        
        runShellScriptAsync(args: ["echo", "hello"]) { process, stdout, stderror in
            XCTAssert(stdout == Optional("hello"))
            XCTAssert(stderror == Optional(""))
            XCTAssert(process.terminationStatus == 0)
            
        }
        
        
    }
    
    
    
    func testTimeUnits() {
        XCTAssertEqual(timeUnit(.hour(1), .minute(2), .second(5)), 3725.0)
    }
   
}


