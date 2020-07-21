//
//  UIViewControllerExtensions.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/12/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import Purchases

extension UIViewController {
    
    func showAlert(title: String = "", message: String, afterConfirm: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let action = afterConfirm {
                action()
            }
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Show FourSix Pro Popup
    func showProPopup(delegate: PaywallDelegate) {
        let storyboard = UIStoryboard(name: IAPManager.shared.proPopUpSBName, bundle: nil)
        guard let popup = storyboard.instantiateInitialViewController() as? PurchaseProVC else { return }
        popup.delegate = delegate
        self.present(popup, animated: true)
    }
    
    // Makes navigation controller bar clear and removes the shadow
    func clearNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
}
