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
        IAPManager.shared.loadOfferings { [weak self] (_, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.titleLabel.text = "Error"
                self.subtitleLabel.text = error
                self.featureListLabel.text = ""
                self.restoreButton.isEnabled = false
                self.purchaseButton.isHidden = true
            } else {
                self.productPrice = IAPManager.shared.productPrice
                self.productName = IAPManager.shared.productName
                self.productDescription = IAPManager.shared.productDescription
                
                self.titleLabel.text = self.productName
                self.subtitleLabel.text = "\(self.productName!) is a one time purchase that unlocks several features and helps support future development."
                self.purchaseButton.setTitle("Get Pro for \(self.productPrice!)", for: .normal)
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
        self.setState(loading: true)
        
        if let package = IAPManager.shared.package {
            IAPManager.shared.purchase(package: package) { [weak self] (succeeded, error) in
                guard let self = self else { return }
                
                self.setState(loading: false)
                
                if succeeded {
                    print("successful purchase")
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
                        AlertHelper.showAlert(title: "Purchase Failed", message: error, on: self)
                    } else {
                        AlertHelper.showAlert(title: "Purchase Failed", message: "Unknown error. Please try again or contact the developer if the error persists.", on: self)
                    }
                }
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
