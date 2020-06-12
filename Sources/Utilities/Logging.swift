import Foundation


open class Logger: Equatable {
    
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
    

    /**
    The closure that gets called when a logging message needs to
    be printed. Use this to customize the format of the message.
    
    - Warning: This is a static variable. **When you change this variable,
               the formatters for all instances of this class are assigned
               to this formatter.**
               An instance variable of the same name also exists.
    ```
    public typealias LogMsgFormatter = (
        _ date: Date, _ label: String, _ level: Levels,
        _ file: UInt, _ function: String, _ line: String,
        _ message: String
    ) -> Void
    ```
    */
    public static var logMsgFormatter: LogMsgFormatter = { (
        date, label, level, file, function, line, message
    ) in
        
        return "\(label): \(level) [\(function):\(line)]: \(message)"
        
    } {
        didSet {
            for logger in allLoggers {
                logger.logMsgFormatter = Logger.logMsgFormatter
            }
            Logger.infoMsgFormatter = Logger.logMsgFormatter
            Logger.debugMsgFormatter = Logger.logMsgFormatter
            Logger.warningMsgFormatter = Logger.logMsgFormatter
            Logger.errorMsgFormatter = Logger.logMsgFormatter
            Logger.criticalMsgFormatter = Logger.logMsgFormatter
        }
    }
    
    /// The log message formatter for info messages. See Logger.logMsgFormatter
    public static var infoMsgFormatter = Logger.logMsgFormatter {
        didSet {
            for logger in allLoggers {
                logger.infoMsgFormatter = Logger.infoMsgFormatter
            }
        }
    }
    /// The log message formatter for info messages. See Logger.logMsgFormatter
    public static var debugMsgFormatter = Logger.logMsgFormatter {
        didSet {
            for logger in allLoggers {
                logger.debugMsgFormatter = Logger.debugMsgFormatter
            }
        }
    }
    /// The log message formatter for info messages. See Logger.logMsgFormatter
    public static var warningMsgFormatter = Logger.logMsgFormatter {
        didSet {
            for logger in allLoggers {
                logger.warningMsgFormatter = Logger.warningMsgFormatter
            }
        }
    }
    /// The log message formatter for info messages. See Logger.logMsgFormatter
    public static var errorMsgFormatter = Logger.logMsgFormatter {
        didSet {
            for logger in allLoggers {
                logger.errorMsgFormatter = Logger.errorMsgFormatter
            }
        }
    }
    
    /// The log message formatter for info messages. See Logger.logMsgFormatter
    public static var criticalMsgFormatter = Logger.logMsgFormatter {
        didSet {
            for logger in allLoggers {
                logger.criticalMsgFormatter = Logger.criticalMsgFormatter
            }
        }
    }
    
    
    
    /**
    The closure that gets called when a logging message needs to
    be printed. Use this to customize the format of the message.
     
    - Note: This is an instance variable. A static variable
            of the same name also exists.
    ```
    public typealias LogMsgFormatter = (
        _ date: Date, _ label: String, _ level: Levels,
        _ file: UInt, _ function: String, _ line: String,
        _ message: String
    ) -> Void
    ```
    */
    public var logMsgFormatter: LogMsgFormatter {
        didSet {
            self.infoMsgFormatter = self.logMsgFormatter
            self.debugMsgFormatter = self.logMsgFormatter
            self.warningMsgFormatter = self.logMsgFormatter
            self.errorMsgFormatter = self.logMsgFormatter
            self.criticalMsgFormatter = self.logMsgFormatter
        }
    }
    
    /// The log message formatter for info messages. See Logger.logMsgFormatter
    public var infoMsgFormatter = Logger.logMsgFormatter
    /// The log message formatter for info messages. See Logger.logMsgFormatter
    public var debugMsgFormatter = Logger.logMsgFormatter
    /// The log message formatter for info messages. See Logger.logMsgFormatter
    public var warningMsgFormatter = Logger.logMsgFormatter
    /// The log message formatter for info messages. See Logger.logMsgFormatter
    public var errorMsgFormatter = Logger.logMsgFormatter
    /// The log message formatter for info messages. See Logger.logMsgFormatter
    public var criticalMsgFormatter = Logger.logMsgFormatter
    
    open var disabled: Bool
    open var label: String
    open var level: Level
    open var id: UUID
    
    public init(
        label: String,
        level: Level = .debug,
        disabled: Bool = false,
        id: UUID = UUID(),
        logMsgFormatter: @escaping LogMsgFormatter =
                Logger.logMsgFormatter
    ) {
        self.label = label
        self.level = level
        self.disabled = disabled
        self.id = id
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
                    callFormatter(self.infoMsgFormatter)
                case .debug:
                    callFormatter(self.debugMsgFormatter)
                case .warning:
                    callFormatter(self.warningMsgFormatter)
                case .error:
                    callFormatter(self.errorMsgFormatter)
                case .critical:
                    callFormatter(self.criticalMsgFormatter)
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
