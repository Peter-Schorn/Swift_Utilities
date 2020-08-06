import Foundation

public extension Decimal {
    
    /// Rounds to the specified number of decimal places
    /// using the sepcified rounding mode.
    mutating func round(
        to decimalPlaces: Int,
        _ roundingMode: NSDecimalNumber.RoundingMode
    ) {
        var localCopy = self
        NSDecimalRound(&self, &localCopy, decimalPlaces, roundingMode)
    }

    /// Returns a new number rounded to the specified number
    /// of decimal places using the sepcified rounding mode.
    func rounded(
        to decimalPlaces: Int,
        _ roundingMode: NSDecimalNumber.RoundingMode
    ) -> Decimal {
        
        var result = Decimal()
        var localCopy = self
        NSDecimalRound(&result, &localCopy, decimalPlaces, roundingMode)
        return result
    }

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

        let nsDecimal = self as NSDecimalNumber
        
        if let currency = CurrencyFormatter(
            locale: locale,
            usesGroupingSeparator: usesGroupingSeparator
        ).string(from: nsDecimal) {
        
            return currency
        }
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: nsDecimal) ??
                "\(self.rounded(to: 2, .up))"
        
    }

}
