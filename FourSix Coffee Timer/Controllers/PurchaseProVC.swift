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
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var featureListLabel: UILabel!
    @IBOutlet var purchaseButton: RoundButton!
    
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
        subtitleLabel.text = "\(productName!) unlocks several features."
        purchaseButton.setTitle("Get Pro for \(productPrice!)", for: .normal)
    }
    
    @IBAction func restorePurchaseTapped(_ sender: Any) {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if let purchaseRestoredHandler = self.delegate?.purchaseRestored {
                purchaseRestoredHandler(self, purchaserInfo, error)
                self.dismiss(animated: true, completion: nil)
            } else {
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    if let purchaserInfo = purchaserInfo {
                        if purchaserInfo.entitlements.active.isEmpty {
                            self.showAlert(title: "Restore Unsuccessful", message: "No prior purchases found for your account.")
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func getProTapped(_ sender: Any) {
        if let package = package {
            Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
                // Check for successful purchase
                if let purchaseCompleteHandler = self.delegate?.purchaseCompleted {
                    purchaseCompleteHandler(self, transaction!, purchaserInfo!)
                    self.dismiss(animated: true, completion: nil)
                }
                
                // Check for errors
                if let err = error as NSError? {
                    // Log error details
                    print("Error: \(String(describing: err.userInfo[Purchases.ReadableErrorCodeKey]))")
                    print("Message: \(err.localizedDescription)")
                    print("Underlying Error: \(String(describing: err.userInfo[NSUnderlyingErrorKey]))")
                    
                    // Handle specific errors
                    switch Purchases.ErrorCode(_nsError: err).code {
                    case .purchaseNotAllowedError:
                        self.showAlert(message: "Purchases not allowed on this device.")
                    case .purchaseInvalidError:
                        self.showAlert(message: "Purchase invalid, check payment source.")
                    default:
                        break
                    }
                }
            }
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
