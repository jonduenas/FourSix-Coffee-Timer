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
                self.restoreButton.isEnabled = false
                self.purchaseButton.isHidden = true
                
                AlertHelper.showConfirmationAlert(title: "Unexpected Error", message: "Unable to load offerings. Please try again later.", confirmButtonTitle: "OK", on: self) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.productPrice = IAPManager.shared.productPrice
                self.productName = IAPManager.shared.productName
                self.productDescription = IAPManager.shared.productDescription
                
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

class PaywallTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var height: CGFloat = 677
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = SlideOverPresentation(presentedViewController: presented, presenting: presenting)
        presentation.height = height
        presentation.tapToDismiss = true
        return presentation
    }
}
