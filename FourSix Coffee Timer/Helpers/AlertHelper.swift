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
    
    static func showRestorePurchaseAlert(on controller: UIViewController, completion: (() -> Void)?) {
        AlertHelper.showCancellableAlert(title: "Restore FourSix Pro",
                                         message: "Would you like to restore your previous purchase of FourSix Pro?",
                                         confirmButtonTitle: "Restore",
                                         dismissButtonTitle: "Cancel",
                                         on: controller) { _ in
            IAPManager.shared.restorePurchases { (_, error) in
                if let err = error {
                    AlertHelper.showAlert(title: "Unexpected Error", message: err, on: controller)
                    return
                }
                
                AlertHelper.showConfirmationAlert(title: "Restore Successful",
                                                  message: "...And we're back! Thanks for being a pro user. Time to brew some coffee.",
                                                  confirmButtonTitle: "Let's Go",
                                                  on: controller)
                if let completion = completion {
                    completion()
                }
            }
        }
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
