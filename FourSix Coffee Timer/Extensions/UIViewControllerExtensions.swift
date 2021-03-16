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
    #warning("Delete these alert functions and use AlertHelper instead")
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
    
    func showAlertWithCancel(title: String = "", message: String, afterConfirm: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let action = afterConfirm {
                action()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Show FourSix Pro Popup
    #warning("Move to coordinators")
    func showProPopup(delegate: PaywallDelegate) {
        let storyboard = UIStoryboard(name: IAPManager.shared.proPopUpSBName, bundle: nil)
        guard let popup = storyboard.instantiateInitialViewController() as? PurchaseProVC else { return }
        popup.delegate = delegate
        self.present(popup, animated: true)
    }
    
    // Makes navigation controller bar clear and removes the shadow
    #warning("Remove this and make sure they're in navigation controllers")
    func clearNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
}
