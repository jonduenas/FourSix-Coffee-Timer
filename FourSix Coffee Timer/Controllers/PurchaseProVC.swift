//
//  PurchaseProVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/12/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import Purchases

@objc protocol PaywallDelegate {
    func purchaseCompleted(paywall: PurchaseProVC, transaction: SKPaymentTransaction, purchaserInfo: Purchases.PurchaserInfo)
    @objc optional func purchaseFailed(paywall: PurchaseProVC, purchaserInfo: Purchases.PurchaserInfo?, error: Error, userCancelled: Bool)
    @objc optional func purchaseRestored(paywall: PurchaseProVC, purchaserInfo: Purchases.PurchaserInfo?, error: Error?)
}

class PurchaseProVC: UIViewController {
    
    var delegate: PaywallDelegate?
    
    var offering: Purchases.Offering?
    var package: Purchases.Package?
    var productPrice: String?
    var productName: String?
    var productDescription: String?
    var defaultRestoreButtonText: String?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var featureListLabel: UILabel!
    @IBOutlet var purchaseButton: LoadingButton!
    @IBOutlet var restoreButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOfferings()
    }
    
    private func loadOfferings() {
        Purchases.shared.offerings { (offerings, error) in
            if error != nil {
                self.showAlert(title: "Error", message: "Unable to fetch offerings.")
            }
            
            self.offering = offerings?.current
            
            
            if self.offering == nil {
                self.showAlert(title: "Error", message: "No offerings found.")
            }
        }
        initializeProducts()
    }
    
    fileprivate func initializeProducts() {
        guard let offering = self.offering else { return }
        package = offering.availablePackages.first
        productName = package?.product.localizedTitle
        productDescription = package?.product.localizedDescription
        productPrice = package?.localizedPriceString
        
        titleLabel.text = productName
        subtitleLabel.text = "\(productName!) is a one time purchase that unlocks several features and helps support future development."
        purchaseButton.setTitle("Get Pro for \(productPrice!)", for: .normal)
    }
    
    @IBAction func restorePurchaseTapped(_ sender: Any) {
        
        setState(loading: true)
        
        // Check if user has already purchased
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            
            self.setState(loading: false)
            
            // Check for error
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                // No error, check if user has made prior purchase
                if let purchaserInfo = purchaserInfo {
                    if purchaserInfo.entitlements.active.isEmpty {
                        self.showAlert(title: "Restore Unsuccessful", message: "No prior purchases found for your account.")
                    } else {
                        self.showAlert(title: "Restore Successful", message: "...And we're back. Let's get brewing.") {
                            self.dismiss(animated: true) {
                                if let purchaseRestoredHandler = self.delegate?.purchaseRestored {
                                    purchaseRestoredHandler(self, purchaserInfo, error)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func getProTapped(_ sender: Any) {
        // Check if user is authorized to make purchases
        if Purchases.canMakePayments() {
            if let package = package {
                
                setState(loading: true)
                
                Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
                    
                    self.setState(loading: false)
                    
                    if let error = error as NSError? {
                        if !userCancelled {
                            // Log error details
                            print("Error: \(String(describing: error.userInfo[Purchases.ReadableErrorCodeKey]))")
                            print("Message: \(error.localizedDescription)")
                            print("Underlying Error: \(String(describing: error.userInfo[NSUnderlyingErrorKey]))")
                            
                            // Handle specific errors
                            switch Purchases.ErrorCode(_nsError: error).code {
                            case .purchaseNotAllowedError:
                                self.showAlert(message: "Purchases not allowed on this device.")
                            case .purchaseInvalidError:
                                self.showAlert(message: "Purchase invalid, check payment source.")
                            default:
                                break
                            }
                        }
                    } else {
                        // Successful purchase
                        if purchaserInfo?.entitlements["pro"]?.isActive == true {
                            self.showAlert(title: "FourSix Pro Successfully Purchased", message: "Thank you for your support! Enjoy all your Pro features.") {
                                [weak self] in
                                self?.dismiss(animated: true, completion: {
                                    if let purchaseCompleteHandler = self?.delegate?.purchaseCompleted {
                                        purchaseCompleteHandler(self!, transaction!, purchaserInfo!)
                                    }
                                })
                            }
                        }
                    }
                }
            }
        } else {
            // User is not authorized
            showAlert(message: "Purchases not allowed on this device.") { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setState(loading: Bool) {
        if loading {
            purchaseButton.showLoading()
            
            defaultRestoreButtonText = restoreButton.titleLabel?.text
            restoreButton.isEnabled = false
            restoreButton.setTitle("Loading...", for: .normal)
            
            closeButton.isHidden = true
        } else {
            purchaseButton.hideLoading()
            
            restoreButton.isEnabled = true
            restoreButton.setTitle(defaultRestoreButtonText, for: .normal)
            
            closeButton.isHidden = false
        }
    }
}
