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
