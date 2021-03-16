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

class IAPManager: NSObject {
    static let shared = IAPManager()
    
    let proPopUpSBName = "FourSixProPopup"
    let entitlementID = "pro"
    let packageID = "Lifetime"
    
    var offering: Purchases.Offering?
    var offeringID: String?
    var package: Purchases.Package?
    var productPrice: String?
    var productName: String?
    var productDescription: String?
    
    func loadOfferings(loadSucceeded: @escaping (Bool, String?) -> Void) {
        
        Purchases.shared.offerings { [weak self] (offerings, error) in
            if error != nil {
                loadSucceeded(false, error!.localizedDescription)
            } else {
                if let offeringID = self?.offeringID {
                    self?.offering = offerings?.offering(identifier: offeringID)
                } else {
                    self?.offering = offerings?.current
                }
                
                if self?.offering == nil {
                    loadSucceeded(false, "No offerings found.")
                } else {
                    self?.package = self?.offering?.availablePackages.first
                    self?.productPrice = self?.package?.localizedPriceString
                    self?.productName = self?.package?.product.localizedTitle
                    self?.productDescription = self?.package?.product.localizedDescription
                    
                    loadSucceeded(true, nil)
                }
            }
        }
    }
    
    func purchase(package: Purchases.Package, purchaseSucceeded: @escaping (Bool, String?) -> Void) {
        if Purchases.canMakePayments() {
            Purchases.shared.purchasePackage(package) { [weak self] (_, purchaserInfo, error, userCancelled) in
                guard let self = self else { return }
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
                        purchaseSucceeded(false, nil)
                    }
                } else {
                    // Successful purchase
                    if purchaserInfo?.entitlements[self.entitlementID]?.isActive == true {
                        purchaseSucceeded(true, nil)
                    } else {
                        purchaseSucceeded(false, nil)
                    }
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
