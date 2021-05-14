//
//  IAPManager.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/13/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation
import Purchases

enum AppStoreReviewManager {
    static let minimumReviewWorthyActionCount = 2
    
    static func requestReviewIfAppropriate() {
        // Check how many actions the user has made
        var actionCount = UserDefaultsManager.reviewWorthyActionCount
        actionCount += 1
        UserDefaultsManager.reviewWorthyActionCount = actionCount
        
        guard actionCount >= minimumReviewWorthyActionCount else { return }
        
        // Check if user has already been asked to review the current version
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = UserDefaultsManager.lastReviewRequestAppVersion
        
        guard lastVersion == nil || lastVersion != currentVersion else { return }
        
        // Request review
        SKStoreReviewController.requestReview()
        
        UserDefaultsManager.reviewWorthyActionCount = 0
        UserDefaultsManager.lastReviewRequestAppVersion = currentVersion
    }
}

struct IAPurchase {
    var name: String?
    var localizedPriceString: String?
    var localizedDescription: String?
}

class IAPManager: NSObject {
    static let shared = IAPManager()
    
    let entitlementID = "pro"
    let tipsPackageID = "tips"
    
    var offerings: Purchases.Offerings?
    
    var proOffering: Purchases.Offering?
    
    var tips: [IAPurchase] = []
    var tipPackages: [Purchases.Package] = []
    
    var fourSixPro: IAPurchase?
    var proPackage: Purchases.Package?
    
    func loadCurrentOffering(loadSucceeded: @escaping (Bool, String?) -> Void) {
        Purchases.shared.offerings { [weak self] (offerings, error) in
            if error != nil {
                loadSucceeded(false, error!.localizedDescription)
            } else {
                self?.proOffering = offerings?.current
                
                if self?.proOffering == nil {
                    loadSucceeded(false, "No offerings found.")
                } else {
                    let pro = self?.proOffering?.lifetime
                    self?.proPackage = pro
                    self?.fourSixPro = IAPurchase(
                        name: pro?.product.localizedTitle,
                        localizedPriceString: pro?.localizedPriceString,
                        localizedDescription: pro?.product.localizedDescription)
                    
                    loadSucceeded(true, nil)
                }
            }
        }
    }
    
    func loadAllOfferings(loadSucceeded: @escaping (Bool, String?) -> Void) {
        Purchases.shared.offerings { [weak self] (offerings, error) in
            if error != nil {
                loadSucceeded(false, error!.localizedDescription)
            } else {
                if let offerings = offerings {
                    self?.offerings = offerings
                    loadSucceeded(true, nil)
                } else {
                    loadSucceeded(false, "No offerings found.")
                }
            }
        }
    }
    
    func loadTips(loadSucceeded: @escaping (Bool, String?) -> Void) {
        Purchases.shared.offerings { [weak self] (offerings, error) in
            if error != nil {
                loadSucceeded(false, error!.localizedDescription)
            } else {
                if let offerings = offerings, let tipProducts = offerings.offering(identifier: self?.tipsPackageID)?.availablePackages {
                    self?.offerings = offerings
                    
                    self?.tips.removeAll()
                    
                    for tipProduct in tipProducts {
                        let tip = IAPurchase(
                            name: tipProduct.product.localizedTitle,
                            localizedPriceString: tipProduct.localizedPriceString,
                            localizedDescription: tipProduct.product.localizedDescription
                        )
                        self?.tips.append(tip)
                    }
                    
                    self?.tipPackages = tipProducts
                    
                    loadSucceeded(true, nil)
                } else {
                    loadSucceeded(false, "No tips found.")
                }
            }
        }
    }
    
    func purchase(package: Purchases.Package, entitlementID: String?, purchaseSucceeded: @escaping (Bool, String?) -> Void) {
        if Purchases.canMakePayments() {
            Purchases.shared.purchasePackage(package) { (_, purchaserInfo, error, userCancelled) in
                if let error = error as NSError? {
                    if !userCancelled {
                        // Log error details
                        let errCode = error.userInfo[Purchases.ReadableErrorCodeKey]
                        let errMessage = error.localizedDescription
                        let errUnderlying = error.userInfo[NSUnderlyingErrorKey]
                        
                        print("Error: \(String(describing: errCode))")
                        print("Message: \(errMessage)")
                        print("Underlying Error: \(String(describing: errUnderlying))")
                        
                        // Handle specific errors
                        switch Purchases.ErrorCode(_nsError: error).code {
                        case .purchaseNotAllowedError:
                            purchaseSucceeded(false, "User not allowed to make purchases on this device.")
                        case .purchaseInvalidError:
                            purchaseSucceeded(false, "Purchase invalid, check payment source.")
                        default:
                            purchaseSucceeded(false, errMessage)
                        }
                    } else {
                        // User cancelled
                        purchaseSucceeded(false, nil)
                    }
                } else {
                    // Successful purchase, double check if user now has active entitlement
                    if let entitlementID = entitlementID {
                        let activeEntitlement = purchaserInfo?.entitlements[entitlementID]?.isActive
                        if activeEntitlement == true {
                            purchaseSucceeded(true, nil)
                        } else {
                            purchaseSucceeded(false, "Unknown error. Please contact developer.")
                        }
                    }
                    
                    // If no check is needed, like for tips, then just mark as successful
                    purchaseSucceeded(true, nil)
                }
            }
        } else {
            purchaseSucceeded(false, "User is not authorized to make purchases on this device.")
        }
    }
    
    func restorePurchases(restoreSucceeded: @escaping (Bool, String?) -> Void) {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if error != nil {
                restoreSucceeded(false, error!.localizedDescription)
            } else {
                if let info = purchaserInfo {
                    if info.entitlements.active.isEmpty {
                        restoreSucceeded(false, "No prior purchases found for your account.")
                    } else {
                        restoreSucceeded(true, nil)
                    }
                }
            }
        }
    }
    
    func userIsPro(proStatus: @escaping (Bool, Error?) -> Void) {
        // Get the latest purchaserInfo to see if user paid for Pro
        Purchases.shared.purchaserInfo { [weak self] (purchaserInfo, error) in
            guard let self = self else { return }
            
            if let err = error {
                print("Error checking user Pro status: \(err)")
                proStatus(false, err)
            }

            if purchaserInfo?.entitlements[self.entitlementID]?.isActive == true {
                proStatus(true, nil)
            } else {
                proStatus(false, nil)
            }
        }
    }
}
