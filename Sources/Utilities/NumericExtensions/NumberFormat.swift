import Foundation

public extension CVarArg {
    
    /**
     Alias for `String(format: specifier, self)`.
     see [String Format Specifiers](https://developer.a.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html)
     - Parameter specifier: the string format specifier.
     - Returns: the formatted string.
     */
    func format(_ specifier: String) -> String {
        return String(format: specifier, self)
    }
    
}


public extension Double {
    
    /**
    Uses `CurrencyFormatter` to convert `self` to
    a currency string. For example, "$5.99".
    
    - Parameters:
      - locale: The desired locale for the currency.
            Leave as nil to use [Locale.autoupdatingCurrent](https://developer.apple.com/documentation/foundation/locale/2293741-autoupdatingcurrent)
          (a locale which tracks the user’s current preferences).
      - usesGroupingSeparator: Determines whether the formatter uses
            the grouping separator. Defaults to `true`.
     
     If, for some reason, the number
     cannot be represented as a currency, then it is returned
     rounded to two decimal digits.
    */
    func asCurrency(
        locale: Locale? = nil,
        usesGroupingSeparator: Bool = true
    ) -> String {
        
        return CurrencyFormatter(locale: locale)
            .string(from: self) ??
            self.format("%.2f")
        
    }
    
    /// Removes **insignificant** trailing zeros.
    func stripingTrailingZeros() -> String {
        return self.format("%g")
    }
    
}
