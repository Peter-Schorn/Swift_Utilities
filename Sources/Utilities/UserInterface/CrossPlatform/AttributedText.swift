 #if canImport(SwiftUI)
import SwiftUI
import Foundation

@available(macOS 10.15, iOS 13, watchOS 6.0, tvOS 13.0, *)
public struct AttributedText: View {

    private var attributedString: NSMutableAttributedString
    private var string: String

    public init(_ string: String) {
        self.init(attributedString: .init(string: string), string: string)
    }
    
    private init(
        attributedString: NSMutableAttributedString,
        string: String
    ) {
        self.attributedString = attributedString
        self.string = string
    }

    public var body: some View {

        // print("---------------------")
        // var counter = 0

        var text = Text(verbatim: "")
        attributedString.enumerateAttributes(
            in: NSRange(location: 0, length: attributedString.length)
        ) { attributes, range, _ in
            
            
            let plainString = attributedString.attributedSubstring(
                from: range
            ).string

            // print("enumerate", counter, plainString)
            
            let textModifiers = attributes.values.map { $0 as! (Text) -> Text }
            
            // var modCounter = 0
            
            let modifiedText = textModifiers.reduce(Text(verbatim: plainString)) {
                text, modifier in
                // print("    mod", modCounter, quoted(text))
                // modCounter += 1
                return modifier(text)
            }
            text = text + modifiedText
            
            // counter += 1
        }
        
        // print("---------------------")
        return text
    }

    
    // MARK: Main style function
    public func style(
        ranges: [Range<String.Index>],
        _ modifier: @escaping (Text) -> Text
    ) -> Self {
        
        for range in ranges {
            attributedString.addAttribute(
                NSAttributedString.Key(UUID().uuidString),
                value: modifier,
                range: NSRange(range, in: string)
            )
        }
        
        return Self(attributedString: attributedString, string: string)
    }
    
    // MARK: Closure Overloads

    public func style(
        range: Range<String.Index>?,
        _ modifier: @escaping (Text) -> Text
    ) -> Self {
        let r = range == nil ? [] : [range!]
        return style(ranges: r, modifier)
    }
    
    // MARK: Full range
    public func style(
        _ modifier: @escaping (Text) -> Text
    ) -> Self {
    
        return style(range: string.startIndex..<string.endIndex, modifier)
    }
    
    
    public enum TextModifier {
        case bold
        case italic
        case strikethrough
        case underline
        case foregroundColor(Color?)
        case font(Font?)
        case fontWeight(Font.Weight?)
        
        public var value: (Text) -> Text {
            switch self {
                case .bold:
                    return { $0.bold() }
                case .italic:
                    return { $0.italic() }
                case .strikethrough:
                    return { $0.strikethrough() }
                case .underline:
                    return { $0.underline() }
                case .foregroundColor(let color):
                    return { $0.foregroundColor(color) }
                case .font(let font):
                    return { $0.font(font) }
                case .fontWeight(let fontWeight):
                    return { $0.fontWeight(fontWeight) }
            }
        }
    }
    
    public struct TextModifier2 {
        
        let modified: (Text) -> Text
        
        public init(_ modified: @escaping (Text) -> Text) {
            self.modified = modified
        }

        static let bold = Self { $0.bold() }
        static let italic = Self { $0.italic() }
        static let strikethrough = Self { $0.strikethrough() }
        static let underline = Self { $0.underline() }

        static func foregroundColor(_ color: Color?) -> Self {
            self.init { $0.foregroundColor(color) }
        }

    }
    
    // MARK: Enum overloads
    
    public func style(
        ranges: [Range<String.Index>],
        _ modifier: TextModifier
    ) -> Self {
    
        return style(ranges: ranges, modifier.value)
    }
    
    public func style(
        range: Range<String.Index>?,
        _ modifier: TextModifier
    ) -> Self {
        return style(range: range, modifier.value)
    }
    
    // MARK: Full range
    public func style(
        _ modifier: TextModifier
    ) -> Self {
    
        return style(range: string.startIndex..<string.endIndex, modifier)
    }
    
    
    
}

#endif
