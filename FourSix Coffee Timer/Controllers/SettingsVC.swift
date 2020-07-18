//
//  SettingsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import Purchases

class SettingsVC: UITableViewController, PaywallDelegate {
    
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

        self.navigationController?.navigationBar.barTintColor = UIColor(named: "Background")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        loadUserDefaults()
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
    
    // Hides cells when user is Pro or not
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
                    return 0.25 // Keeps top border of section
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
                let ac = UIAlertController(title: "Restore FourSix Pro", message: "Would you like to restore your previous purchase of FourSix Pro?", preferredStyle: .alert)
                ac.addAction(cancelAction)
                ac.addAction(UIAlertAction(title: "Restore", style: .default, handler: { _ in
                    Purchases.shared.restoreTransactions { (purchaserInfo, error) in
                        if let error = error {
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        } else {
                            // No error, check if user has made prior purchase
                            if let purchaserInfo = purchaserInfo {
                                if purchaserInfo.entitlements.active.isEmpty {
                                    self.showAlert(title: "Restore Unsuccessful", message: "No prior purchases found for your account.")
                                } else {
                                    self.showAlert(title: "Restore Successful", message: "...And we're back. Let's get brewing.") { [weak self] in
                                        self?.enablePro(true)
                                    }
                                }
                            }
                        }
                    }
                }))
                present(ac, animated: true, completion: nil)
            
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
                //TODO: Add code for iPad compatibility
//                let cellRect = tableView.rectForRow(at: indexPath)
//                ac.popoverPresentationController?.sourceView = tableView
//                ac.popoverPresentationController?.sourceRect = cellRect
//                ac.popoverPresentationController?.canOverlapSourceViewRect = true
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
                    if let url = URL(string: "https://www.twitter.com/foursixcoffee") {
                        UIApplication.shared.open(url)
                    }
                }))
                present(ac, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
            return "v\(appVersionString)-beta.\(buildNumber)"
        } else {
            return nil
        }
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
                    self_.delegate.checkForPro()
                }
            }
        }
    }
}
