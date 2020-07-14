//
//  UIViewController+showAlert.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/12/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import Purchases

extension UIViewController {
    
    func showAlert(title: String = "", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Show FourSix Pro Popup
    func showProPopup(delegate: PaywallDelegate) {
        let sb = UIStoryboard(name: IAPManager.proPopUpSBName, bundle: nil)
        let popup = sb.instantiateInitialViewController() as! PurchaseProVC
        popup.delegate = delegate
        self.present(popup, animated: true)
    }
}
