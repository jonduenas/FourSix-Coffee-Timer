//
//  PurchaseProVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/12/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class PurchaseProVC: UIViewController, Storyboarded {
    weak var delegate: PaywallDelegate?
    var fourSixPro: IAPurchase?
    var productPrice: String?
    var productName: String?
    var productDescription: String?
    var defaultRestoreButtonText: String?
    
    @IBOutlet var purchaseButton: LoadingButton!
    @IBOutlet var restoreButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOfferings()
    }
    
    private func loadOfferings() {
        IAPManager.shared.loadCurrentOffering { [weak self] (_, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.restoreButton.isEnabled = false
                self.purchaseButton.isHidden = true
                
                AlertHelper.showConfirmationAlert(title: "Unexpected Error", message: "Unable to load offerings. Please try again later.", confirmButtonTitle: "OK", on: self) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                if let fourSixPro = IAPManager.shared.fourSixPro, let price = fourSixPro.localizedPriceString {
                    self.purchaseButton.setTitle("Get Pro for \(price)", for: .normal)
                    self.fourSixPro = fourSixPro
                } else {
                    AlertHelper.showConfirmationAlert(title: "Unexpected Error", message: "Unable to load offerings. Please try again later.", confirmButtonTitle: "OK", on: self) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func restorePurchaseTapped(_ sender: Any) {
        setState(loading: true)
        
        AlertHelper.showRestorePurchaseAlert(on: self,
                                             cancelHandler: { [weak self] _ in
                                                self?.setState(loading: false)
                                             },
                                             completion: { [weak self] in
                                                self?.setState(loading: false)
                                                self?.dismiss(animated: true) {
                                                    if let purchaseRestoreHandler = self?.delegate?.purchaseRestored {
                                                        purchaseRestoreHandler()
                                                    }
                                                }
                                             })
    }
    
    @IBAction func getProTapped(_ sender: Any) {
        guard let package = IAPManager.shared.proPackage else {
            AlertHelper.showAlert(title: "Error", message: "There was an error finding the product for purchasing.", on: self)
            return
        }
        
        self.setState(loading: true)
        
        IAPManager.shared.purchase(package: package, entitlementID: IAPManager.shared.entitlementID) { [weak self] (succeeded, error) in
            guard let self = self else { return }
            
            self.setState(loading: false)
            
            if succeeded {
                AlertHelper.showConfirmationAlert(title: "FourSix Pro Successfully Purchased", message: "Thank you for your support! Time to take your coffee to the next level.", confirmButtonTitle: "Let's Go", on: self) { [weak self] _ in
                    self?.dismiss(animated: true) {
                        if let purchaseCompleteHandler = self?.delegate?.purchaseCompleted {
                            purchaseCompleteHandler()
                        }
                    }
                }
            } else {
                if let error = error {
                    print(error)
                    AlertHelper.showAlert(
                        title: "Purchase Failed",
                        message: """
                            There was an error during the transaction. You were not charged. Please try again.
                            
                            Error: \(error)
                            """,
                        on: self)
                }
            }
        }
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
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
