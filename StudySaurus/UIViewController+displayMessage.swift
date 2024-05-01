//
//  UIViewController+displayMessage.swift
//  FIT3178-W01-Lab
//
//  Created by Isha Kaur on 6/3/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
         preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
         handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
