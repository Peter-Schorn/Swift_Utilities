//
//  File.swift
//  
//
//  Created by Peter Schorn on 5/23/20.
//

#if !os(macOS)


import Foundation
import UIKit

/**
 Wrapper function for creating alerts
 - Parameters:
   - title: The title of the alert
   - msg: The message to display in the alert
   - buttons: A list of Strings representing the names of the buttons.
           Default is "OK" button
   - style: The style of the alert. Either .alert (default) or .actionsheet
 - Returns: the alert
 
 - Warning: This function should be called on the main thread
 */
func makeAlert(
    title: String? = nil,
    msg: String? = nil,
    buttons: [String] = ["OK"],
    style: UIAlertController.Style = .alert
) -> UIAlertController {
    
    let alert = UIAlertController(
        title: title, message: msg, preferredStyle: style
    )
    
    for button in buttons {
        alert.addAction(
            UIAlertAction(title: button, style: .default, handler: nil)
        )
    }
    
    return alert
}


#endif
