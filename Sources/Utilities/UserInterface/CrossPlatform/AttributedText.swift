#if canImport(SwiftUI)

import SwiftUI


@available(macOS 10.15, iOS 13, *)
struct AttributedText: View {

    private var attributedString: NSMutableAttributedString
    private var string: String

    init(_ string: String) {
        self.init(attributedString: .init(string: string), string: string)
    }
    
    private init(
        attributedString: NSMutableAttributedString,
        string: String
    ) {
        self.attributedString = attributedString
        self.string = string
    }

    var body: some View {

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
                modCounter += 1
                return modifier(text)
            }
            text = text + modifiedText
            
            // counter += 1
        }
        
        // print("---------------------")
        return text
    }

    
    // MARK: Main style function
    func style(
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

    func style(
        range: Range<String.Index>?,
        _ modifier: @escaping (Text) -> Text
    ) -> Self {
        let r = range == nil ? [] : [range!]
        return style(ranges: r, modifier)
    }
    
    // MARK: Full range
    func style(
        _ modifier: @escaping (Text) -> Text
    ) -> Self {
    
        return style(range: string.startIndex..<string.endIndex, modifier)
    }
    
    
    enum TextModifier {
        case bold
        case italic
        case strikethrough
        case underline
        case foregroundColor(Color?)
        case font(Font?)
        case fontWeight(Font.Weight?)
        
        var value: (Text) -> Text {
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
    
    // MARK: Enum overloads
    
    func style(
        ranges: [Range<String.Index>],
        _ modifier: TextModifier
    ) -> Self {
    
        return style(ranges: ranges, modifier.value)
    }
    
    func style(
        range: Range<String.Index>?,
        _ modifier: TextModifier
    ) -> Self {
        return style(range: range, modifier.value)
    }
    
    // MARK: Full range
    func style(
        _ modifier: TextModifier
    ) -> Self {
    
        return style(range: string.startIndex..<string.endIndex, modifier)
    }
    
    
    
}



#endif
