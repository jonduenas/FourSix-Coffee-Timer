//
//  IAPManager.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/13/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation
import Purchases

class IAPManager: NSObject {
    static let proPopUpSBName = "FourSixProPopup"
    
    static func isUserPro() -> Bool {
        var proUser = false
        // Get the latest purchaserInfo to see if user paid for Pro
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            // Route the view depending if user is Pro or not
            if purchaserInfo?.entitlements["pro"]?.isActive == true {
                proUser = true
            } else {
                proUser = false
            }
        }
        return proUser
    }
    
    static func restorePurchases() {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            if purchaserInfo?.entitlements["pro"]?.isActive == true {
                
            }
        }
    }
}
