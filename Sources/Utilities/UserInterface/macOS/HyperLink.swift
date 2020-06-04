//
//  File.swift
//  
//
//  Created by Peter Schorn on 6/4/20.
//

import SwiftUI
import AppKit

#if os(macOS)

/**
 Displays text as a hyperlink.
 When the user hovers over the text,
 it becomes underlined and the cursor changes
 to a pointer. You can customize what happens
 when the user clicks on the link. By default,
 it is opened in the browser.
 */
@available(macOS 10.15, *)
public struct HyperLink: View {

    public init(
        link: URL? = nil,
        displayText: String,
        openLinkHandler: @escaping (URL) -> Void = { NSWorkspace.shared.open($0) }
    ) {
        self.init(
            link: link ?? URL(string: displayText),
            displayText: Text(displayText),
            openLinkHandler: openLinkHandler
        )
    }
    
    
    public init(
        link: URL?,
        displayText: Text,
        openLinkHandler: @escaping (URL) -> Void = { NSWorkspace.shared.open($0) }
    ) {
    
        self.displayText = displayText
        self.url = link
        self.openLinkHandler = openLinkHandler
        
    }
    
    
    @State private var isHoveringOverURL = false
    
    let displayText: Text
    let url: URL?
    let openLinkHandler: (URL) -> Void
    
    public var body: some View {
        
        Button(action: {
            if let url = self.url {
                self.openLinkHandler(url)
            }
        }) {
            displayText
                .foregroundColor(Color.blue)
                .if(isHoveringOverURL) {
                    $0.underline()
                }
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { inside in
            if inside {
                self.isHoveringOverURL = true
                NSCursor.pointingHand.push()
            } else {
                self.isHoveringOverURL = false
                NSCursor.pop()
            }
        }
        
        
    }
    
    
}


#endif
