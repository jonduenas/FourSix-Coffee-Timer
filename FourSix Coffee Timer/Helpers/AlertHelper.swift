//
//  AlertHelper.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/15/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

typealias AlertHandler = (UIAlertAction) -> Void

class AlertHelper {
    static func showAlert(title: String?, message: String?, on controller: UIViewController) {
        assert((title ?? message) != nil, "Title OR message must be passed in")
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(.ok)
        controller.present(alert, animated: true)
    }
    
    static func showCancellableAlert(title: String?, message: String?, confirmButtonTitle: String, dismissButtonTitle: String, on controller: UIViewController, handler: AlertHandler? = nil) {
        assert((title ?? message) != nil, "Title OR message must be passed in")
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmButtonTitle,
                                      style: .default,
                                      handler: handler))
        alert.addAction(UIAlertAction(title: dismissButtonTitle,
                                      style: .cancel,
                                      handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showConfirmationAlert(title: String?, message: String?, confirmButtonTitle: String, on controller: UIViewController, handler: AlertHandler? = nil) {
        assert((title ?? message) != nil, "Title OR message must be passed in")
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmButtonTitle,
                                      style: .default,
                                      handler: handler))
        controller.present(alert, animated: true, completion: nil)
    }
}

extension UIAlertAction {
    static var ok: UIAlertAction {
        return UIAlertAction(title: "OK", style: .default, handler: nil)
    }
    
    static var cancel: UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}
