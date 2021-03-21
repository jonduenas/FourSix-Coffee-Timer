//
//  AppDelegate.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/20/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import Purchases

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure RevenueCat with public API key
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: Constants.revenueCatAPIKey)
        Purchases.shared.syncPurchases { (purchaserInfo, error) in
            print(purchaserInfo?.entitlements.active)
            print(error)
        }
        
        return true
    }
}
