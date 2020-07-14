//
//  SettingsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import Purchases

class SettingsVC: UITableViewController, UIAdaptivePresentationControllerDelegate, PaywallDelegate {
    
    //MARK: Constants
    let delegate: BrewVC
    let defaultRatio = 15
    let ratioArray = [12, 13, 14, 15, 16, 17, 18]
    let proFeatures = "customizing your brew Recipe, the option to manually advance steps in the Timer, access to new Pro features coming in the future, and you'll be supporting an independent one-man develeopment team."
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let okActionNoClosure = UIAlertAction(title: "OK", style: .default)
    
    //MARK: Variables
    var ratio = 15 {
        didSet {
            ratioLabel.text = "1:\(ratio)"
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet var showTotalTimeSwitch: UISwitch!
    @IBOutlet var timerAutoAdvanceSwitch: UISwitch!
    @IBOutlet var ratioLabel: UILabel!
    @IBOutlet var settingsTableView: UITableView!
    
    init?(coder: NSCoder, delegate: BrewVC) {
        self.delegate = delegate
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.presentationController?.delegate = self
        
        self.isModalInPresentation = true

        self.navigationController?.navigationBar.barTintColor = UIColor(named: "Background")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        loadUserDefaults()
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismiss(animated: true) { [weak self] in
            if UserDefaultsManager.ratio == 0 {
                UserDefaultsManager.ratio = 15
            } else {
                self?.delegate.ratio = UserDefaultsManager.ratio
            }
        }
    }
    
    fileprivate func loadUserDefaults() {
        if UserDefaultsManager.totalTimeShown {
            showTotalTimeSwitch.isOn = true
        } else {
            showTotalTimeSwitch.isOn = false
        }
        
        if UserDefaultsManager.timerAutoAdvanceOff {
            timerAutoAdvanceSwitch.isOn = false
        } else {
            timerAutoAdvanceSwitch.isOn = true
        }
        
        if UserDefaultsManager.ratio != 0 {
            ratio = UserDefaultsManager.ratio
        }
    }
    
    func purchaseCompleted(paywall: PurchaseProVC, transaction: SKPaymentTransaction, purchaserInfo: Purchases.PurchaserInfo) {
        if purchaserInfo.entitlements["pro"]?.isActive == true {
            enablePro(true)
        }
    }
    
    func purchaseRestored(paywall: PurchaseProVC, purchaserInfo: Purchases.PurchaserInfo?, error: Error?) {
        if purchaserInfo?.entitlements["pro"]?.isActive == true {
            enablePro(true)
        }
    }
    
    private func enablePro(_ enable: Bool) {
        if enable {
            tableView.reloadData()
        }
    }
    
    //MARK: TableView Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                // Coffee:Water Ratio
                if IAPManager.isUserPro() {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            } else if indexPath.row == 3 {
                // Timer Auto-Advance
                if IAPManager.isUserPro() {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            }
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // Purchase FourSix Pro
                showProPopup(delegate: self)
            } else if indexPath.row == 1 {
                // Restore Purchase of FourSix Pro
                Purchases.shared.restoreTransactions { (purchaserInfo, error) in
                    if let e = error {
                        print(e.localizedDescription)
                    }
                    
                    if purchaserInfo?.entitlements["pro"]?.isActive == true {
                        self.enablePro(true)
                        self.showAlert(title: "Restored Purchase", message: "Welcome back! Let's start brewing.")
                    }
                }
            } else if indexPath.row == 2 {
                // Coffee:Water Ratio
                let ac = UIAlertController(title: "Coffee:Water Ratio", message: "Lower numbers = stronger coffee.", preferredStyle: .actionSheet)
                
                for ratio in ratioArray {
                    ac.addAction(UIAlertAction(title: "1:\(ratio)", style: .default, handler: { [weak self] _ in
                        self?.ratio = ratio
                        UserDefaultsManager.ratio = ratio
                    }))
                }
                ac.addAction(UIAlertAction(title: "Restore Default", style: .default, handler: { [weak self] _ in
                    self?.ratio = self!.defaultRatio
                    UserDefaultsManager.ratio = self!.defaultRatio
                }))
                ac.addAction(cancelAction)
                present(ac, animated: true)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 3 {
                // Send Feedback
                let ac = UIAlertController(title: "Opening...", message: "Sending you to Twitter to give feedback.", preferredStyle: .alert)
                ac.addAction(cancelAction)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    if let url = URL(string: "https://www.twitter.com/jonduenas") {
                        UIApplication.shared.open(url)
                    }
                }))
                present(ac, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func showTotalTimeSwitched(_ sender: UISwitch) {
        if showTotalTimeSwitch.isOn {
            UserDefaultsManager.totalTimeShown = true
        } else {
            UserDefaultsManager.totalTimeShown = false
        }
    }
    
    @IBAction func timerAutoAdvanceSwitched(_ sender: Any) {
        if timerAutoAdvanceSwitch.isOn {
            UserDefaultsManager.timerAutoAdvanceOff = false
        } else {
            UserDefaultsManager.timerAutoAdvanceOff = true
        }
    }
    
    //MARK: IAP Methods
    
//    func purchasePro() {
//        // Purchase FourSixPro
//        Purchases.shared.offerings { (offerings, error) in
//            if let packages = offerings?.current?.availablePackages {
//                self.showPaywall(packages: packages)
//            }
//        }
//    }
    
//    func showPaywall(packages: [Purchases.Package]) {
//        if let package = packages.first {
//            let productPrice = package.localizedPriceString
//            let productName = package.product.localizedTitle
//
//            let ac = UIAlertController(title: "Purchase \(productName)", message: "Would you like to purchase \(productName) for \(productPrice)? This gives you \(proFeatures)", preferredStyle: .alert)
//            ac.addAction(cancelAction)
//            ac.addAction(UIAlertAction(title: "Purchase", style: .default, handler: { _ in
//                Purchases.shared.purchaseProduct(package.product) { (transaction, purchaserInfo, error, userCancelled) in
//                    // Check for successful purchase
//                    if purchaserInfo?.entitlements["pro"]?.isActive == true {
//                        print("Pro purchase successful - unlock features")
//                    }
//
//                    // Check for errors
//                    if let err = error as NSError? {
//                        // Log error details
//                        print("Error: \(String(describing: err.userInfo[Purchases.ReadableErrorCodeKey]))")
//                        print("Message: \(err.localizedDescription)")
//                        print("Underlying Error: \(String(describing: err.userInfo[NSUnderlyingErrorKey]))")
//
//                        // Handle specific errors
//                        switch Purchases.ErrorCode(_nsError: err).code {
//                        case .purchaseNotAllowedError:
//                            self.showAlert(message: "Purchases not allowed on this device.")
//                        case .purchaseInvalidError:
//                            self.showAlert(message: "Purchase invalid, check payment source.")
//                        default:
//                            break
//                        }
//                    }
//                }
//            }))
//            present(ac, animated: true, completion: nil)
//        }
//    }

    //MARK: Navigation Methods
    
    @IBAction func xTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            if let self_ = self {
                if UserDefaultsManager.ratio == 0 {
                    UserDefaultsManager.ratio = self_.defaultRatio
                } else {
                    self_.delegate.ratio = UserDefaultsManager.ratio
                }
                if IAPManager.isUserPro() {
                    self_.delegate.enableProFeatures(true)
                }
            }
        }
    }
    
    
}
