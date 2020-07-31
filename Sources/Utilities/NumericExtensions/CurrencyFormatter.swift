import Foundation

public extension NumberFormatter {

    /// Calls `self.string(from: NSNumber(value: number))`.
    func string(from number: Double) -> String? {
        return self.string(from: NSNumber(value: number))
    }
    
    /// Calls `self.string(from: number as NSDecimalNumber)`.
    func string(from number: Decimal) -> String? {
        return self.string(from: number as NSDecimalNumber)
    }
    
}


/// A Subclass of NumberFormatter that provides a
/// convience initializer for creating a formatter for currency.
public class CurrencyFormatter: NumberFormatter {
    
    /**
     Creates an instance that uses the specified locale.
    
     - Parameters:
       - locale: The desired locale for the currency.
             Leave as nil to use [Locale.autoupdatingCurrent](https://developer.apple.com/documentation/foundation/locale/2293741-autoupdatingcurrent)
             (a locale which tracks the user’s current preferences).
       - usesGroupingSeparator: Determines whether the formatter uses
             the grouping separator. Defaults to `true`.
     - Returns: A currency formatter.
    */
    public init(
        locale: Locale? = nil,
        usesGroupingSeparator: Bool = true
    ) {
        super.init()
        self.usesGroupingSeparator = usesGroupingSeparator
        self.numberStyle = .currency
        self.locale = locale ?? .autoupdatingCurrent
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
