#if canImport(SwiftUI)

import Foundation
import SwiftUI


@available(macOS 10.15, iOS 13, watchOS 6.0, tvOS 13.0, *)
extension View {

    /// Horizontally centers the view by embedding it
    /// in a HStack bookended by Spacers.
    func horizontallyCentered() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
    
}



@available(macOS 10.15, iOS 13, watchOS 6.0, tvOS 13.0, *)
public extension View {

    /// Conditionally applies a modifier to a view.
    func `if`<Content: View>(
        _ conditional: Bool,
        content: (Self) -> Content
    ) -> some View {
        if conditional {
            return AnyView(content(self))
        }
        else {
            return AnyView(self)
        }
    }
    
    
    /// Conditionally applies a modifier to a view.
    func `if`<Content: View>(
        _ conditional: Bool,
        _ content1: (Self) -> Content,
        else content2: (Self) -> Content
    ) -> some View {
        
        if conditional {
            return AnyView(content1(self))
        }
        else {
            return AnyView(content2(self))
        }
       
    }

}


#endif
