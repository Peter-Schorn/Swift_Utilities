//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/15/20.
//

import Foundation
import SwiftUI


public struct CenterInForm<V: View>: View {
    
    public var content: V
    
    public init(_ content: V) { self.content = content }
    
    public var body: some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}



#if os(iOS)
extension Color {

    public init(hex: String) {

        var hex = hex
        if hex.hasPrefix("#") { hex.removeFirst() }

        let r, g, b, a: CGFloat
        var hexNumber: UInt64 = 0
        let scanner = Scanner(string: hex)

        scanner.scanHexInt64(&hexNumber)
        
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255

        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        self.init(color)
    }
    
}
#endif
