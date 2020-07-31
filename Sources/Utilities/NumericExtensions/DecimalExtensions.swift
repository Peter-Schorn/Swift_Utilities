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
     Formats the decimal as a currency string using
     the given locale.
    
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

extension Decimal: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        guard let decimal = Decimal(string: value) else {
            fatalError(
                "Could not convert string literal " +
                "'\(value)' to decimal"
            )
        }
        self = decimal
    }

    
}
