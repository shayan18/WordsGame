//
//  UIViewControllerExt.swift
//  WordGame
//
//  Created by Shayan Ali on 19.07.22.
//

import UIKit

extension UIViewController {
  func showAlert(with title: String? = nil,
                 and message: String? = nil,
                 actionTitle: String? = "Ok",
                 handler: ((UIAlertAction) -> Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: actionTitle, style: .default, handler: handler)
    alertController.addAction(action)
    present(alertController, animated: true, completion: nil)
  }
}

