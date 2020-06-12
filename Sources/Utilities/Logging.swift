import Foundation


open class Logger: Equatable, Identifiable, Hashable {
    
    /// The type of the closure that determines
    /// how the log message is formatted.
    public typealias LogMsgFormatter = (
        _ date: Date, _ label: String, _ level: Level,
        _ file: String, _ function: String, _ line: UInt,
        _ message: String
    ) -> String
    
    
    /// All of the instances of this class.
    public static var allLoggers: [Logger] = []
    
    /// Enables/disables all loggers.
    open class var allDisabled: Bool {
        get {
            return allLoggers.allSatisfy { logger in
                logger.disabled
            }
        }
        set {
            for logger in allLoggers {
                logger.disabled = newValue
            }
        }
    }
    
    /// Sets the logging level for all loggers.
    open class func setLevel(to level: Level) {
        for logger in allLoggers {
            logger.level = level
        }
    }
    
    
    final public class func == (lhs: Logger, rhs: Logger) -> Bool {
        return lhs.id == rhs.id
    }
    
    final public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    

    /**
    The closure that gets called when a logging message needs to
    be printed. Use this to customize the format of the message
    for **all** log levels. This is used when the formatter for a
    specific log level is left as nil.
    
    ```
    public typealias LogMsgFormatter = (
        _ date: Date, _ label: String, _ level: Levels,
        _ file: UInt, _ function: String, _ line: String,
        _ message: String
    ) -> String
    ```
    */
    public var logMsgFormatter: LogMsgFormatter
    
    /// The formatter for customizing how info messages are logged.
    /// If left nil, then `logMsgFormatter` will be used for formatting messages.
    /// See also `logMsgFormatter`
    public var infoMsgFormatter: LogMsgFormatter? = nil
    /// The formatter for customizing how debug messages are logged.
    /// If left nil, then `logMsgFormatter` will be used for formatting messages.
    /// See also `logMsgFormatter`
    public var debugMsgFormatter: LogMsgFormatter? = nil
    /// The formatter for customizing how warning messages are logged.
    /// If left nil, then `logMsgFormatter` will be used for formatting messages.
    /// See also `logMsgFormatter`
    public var warningMsgFormatter: LogMsgFormatter? = nil
    /// The formatter for customizing how error messages are logged.
    /// If left nil, then `logMsgFormatter` will be used for formatting messages.
    /// See also `logMsgFormatter`
    public var errorMsgFormatter: LogMsgFormatter? = nil
    /// The formatter for customizing how critical messages are logged.
    /// If left nil, then `logMsgFormatter` will be used for formatting messages.
    /// See also `logMsgFormatter`
    public var criticalMsgFormatter: LogMsgFormatter? = nil
    
    /// Completely disbles all logging messages reglardless of level
    open var disabled: Bool
    /// A string identifying the log level.
    open var label: String
    /// The level of the logger. See `Level`
    open var level: Level
    public let id = UUID()
    
    
    public init(
        label: String,
        level: Level = .debug,
        disabled: Bool = false,
        logMsgFormatter: @escaping LogMsgFormatter = {
            date, label, level, file, function, line, message
        in
        
            return "\(label): \(level) [\(function):\(line)]: \(message)"
        }
    ) {
        self.label = label
        self.level = level
        self.disabled = disabled
        self.logMsgFormatter = logMsgFormatter
        
        Logger.allLoggers.append(self)
    }
    
    deinit {
        Logger.allLoggers.removeAll { logger in
            logger == self
        }
    }
    
    
    /// Logs a message. Unless the log level is determined dynamically,
    /// you should normally use
    /// self.info, self.debug, self.warning, self.error, or self.critical
    /// to log a message at a given level.
    open func log(
        level: Level,
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        logMsgFormatter: LogMsgFormatter? = nil
    ) {
        
        guard level >= self.level && !disabled else {
            return
        }
        
        let callFormatter = { (formatter: LogMsgFormatter) in
            print(formatter(
                Date(), self.label, level, file, function, line, message
            ))
        }
            
        if let formatter = logMsgFormatter {
            callFormatter(formatter)
        }
        else {
            switch level {
                case .info:
                    callFormatter(self.infoMsgFormatter ?? self.logMsgFormatter)
                case .debug:
                    callFormatter(self.debugMsgFormatter ?? self.logMsgFormatter)
                case .warning:
                    callFormatter(self.warningMsgFormatter ?? self.logMsgFormatter)
                case .error:
                    callFormatter(self.errorMsgFormatter ?? self.logMsgFormatter)
                case .critical:
                    callFormatter(self.criticalMsgFormatter ?? self.logMsgFormatter)
            }
        }
        
    }
    
    open func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        infoMsgFormatter: LogMsgFormatter? = nil
    ) {
        
        let formatter = infoMsgFormatter ?? self.infoMsgFormatter
        
        self.log(
            level: .info, message,
            file: file, function: function, line: line,
            logMsgFormatter: formatter
        )
    }
    
    open func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        debugMsgFormatter: LogMsgFormatter? = nil
    ) {
        let formatter = debugMsgFormatter ?? self.debugMsgFormatter
        
        self.log(
            level: .debug, message,
            file: file, function: function, line: line,
            logMsgFormatter: formatter
        )
    }
    
    open func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        warningMsgFormatter: LogMsgFormatter? = nil
    ) {
        let formatter = warningMsgFormatter ?? self.warningMsgFormatter
        
        self.log(
            level: .warning, message,
            file: file, function: function, line: line,
            logMsgFormatter: formatter
        )
    }
    
    open func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        errorMsgFormatter: LogMsgFormatter? = nil
    ) {
        let formatter = errorMsgFormatter ?? self.errorMsgFormatter
        
        self.log(
            level: .error, message,
            file: file, function: function, line: line,
            logMsgFormatter: formatter
        )
    }
    
    open func critical(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        criticalMsgFormatter: LogMsgFormatter? = nil
    ) {
        let formatter = criticalMsgFormatter ?? self.criticalMsgFormatter
        
        self.log(
            level: .critical, message,
            file: file, function: function, line: line,
            logMsgFormatter: formatter
        )
    }
    
    
    /// The log level of the logger.
    public enum Level: Int, Comparable {
        
        case info
        case debug
        case warning
        case error
        case critical
        
        public static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }
    
    
    
    
    
}
