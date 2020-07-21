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
        // Override point for customization after application launch.
        
        // Configure RevenueCat with public API key
        Purchases.debugLogsEnabled = false
        Purchases.configure(withAPIKey: "dDIhCeApJetzFIZVnXDjcLxLTPTjIoyr")
        
        //change appearance of page control
        let pageControl = UIPageControl.appearance()
        pageControl.currentPageIndicatorTintColor = .systemGray
        pageControl.pageIndicatorTintColor = .systemGray4
        
        return true
    }
}
