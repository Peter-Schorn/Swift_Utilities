//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/10/20.
//

import Foundation


public extension Double {
    
   
    /**
     Alias for `String(format: specifier, self)`
     see [String ForSpecifiers](https://developer.a.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html)
     - Parameter specifier: string format specifier.
     - Returns: formatted string
     */
    func format(_ specifier: String) -> String {
        return String(format: specifier, self)
    }

    enum FormatOption {
        case currency, stripTrailingZeros
    }
    /// Formats string according to specifier
    ///
    /// FormatOptions: currency, stripTrailingZeros
    func format(_ specifier: FormatOption) -> String {
        switch specifier {
            case .currency:
                return "$" + self.format("%.2f")
            case .stripTrailingZeros:
                return self.format("%g")
            
        }
    }




}
