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
    let stepAdvanceArray = ["Auto", "Manual"]
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let okActionNoClosure = UIAlertAction(title: "OK", style: .default)
    
    //MARK: Variables
    var ratio = 15 {
        didSet {
            ratioLabel.text = "1:\(ratio)"
            UserDefaultsManager.ratio = ratio
        }
    }
    
    var stepAdvance = 0 {
        didSet {
            stepAdvanceLabel.text = stepAdvanceArray[stepAdvance]
            UserDefaultsManager.timerStepAdvance = stepAdvance
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet var showTotalTimeSwitch: UISwitch!
    @IBOutlet var stepAdvanceLabel: UILabel!
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
        
        stepAdvance = UserDefaultsManager.timerStepAdvance
        
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
            if indexPath.row == 0 {
                // Purchase FourSix Pro
                if IAPManager.isUserPro() {
                    return 0
                } else {
                    return UITableView.automaticDimension
                }
            } else if indexPath.row == 1 {
                // Restore Purchase
                if IAPManager.isUserPro() {
                    return 0
                } else {
                    return UITableView.automaticDimension
                }
            } else if indexPath.row == 2 {
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
                    }))
                }
                ac.addAction(UIAlertAction(title: "Restore Default", style: .default, handler: { [weak self] _ in
                    self?.ratio = self!.defaultRatio
                }))
                ac.addAction(cancelAction)
                present(ac, animated: true)
            } else if indexPath.row == 3 {
                // Timer Step Advance
                let ac = UIAlertController(title: "Timer Step Advance", message: nil, preferredStyle: .actionSheet)
                
                for (index, option) in stepAdvanceArray.enumerated() {
                    ac.addAction(UIAlertAction(title: option, style: .default, handler: { [weak self] _ in
                        self?.stepAdvance = index
                        print(index)
                    }))
                }
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

    //MARK: Navigation Methods
    
    @IBAction func closeTapped(_ sender: Any) {
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
