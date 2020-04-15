//
//  File.swift
//  
//
//  Created by Peter Schorn on 4/15/20.
//

import Foundation
import SwiftUI


struct CenterInForm<V: View>: View {
    
    var content: V
    
    init(_ content: V) { self.content = content }
    
    var body: some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}
