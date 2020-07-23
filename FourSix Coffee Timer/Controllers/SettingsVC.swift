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
    
    // MARK: Constants
    private let defaultRatio = 15
    private let ratioArray = [12, 13, 14, 15, 16, 17, 18]
    private let stepAdvanceArray = ["Auto", "Manual"]
    private let productURL = URL(string: "https://apps.apple.com/app/id1519905670")!
    
    private let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    private let okActionNoClosure = UIAlertAction(title: "OK", style: .default)
    
    // MARK: Variables
    weak var delegate: BrewVC?
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
    
    // MARK: IBOutlets
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
    
    func checkForPro() {
        if IAPManager.shared.userIsPro() {
            enableProFeatures(true)
        } else {
            enableProFeatures(false)
        }
    }
    
    func purchaseCompleted() {
        checkForPro()
    }
    
    func purchaseRestored() {
        checkForPro()
    }
    
    private func enableProFeatures(_ enable: Bool) {
        if enable {
            tableView.reloadData()
        }
    }
    
    // MARK: TableView Methods
    
    // Hides cells when user is Pro or not
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // Purchase FourSix Pro
                if IAPManager.shared.userIsPro() {
                    return 0
                } else {
                    return UITableView.automaticDimension
                }
            } else if indexPath.row == 1 {
                // Restore Purchase
                if IAPManager.shared.userIsPro() {
                    return 0.25 // Keeps top border of section
                } else {
                    return UITableView.automaticDimension
                }
            } else if indexPath.row == 2 {
                // Coffee:Water Ratio
                if IAPManager.shared.userIsPro() {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            } else if indexPath.row == 3 {
                // Timer Auto-Advance
                if IAPManager.shared.userIsPro() {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            }
        }
        return UITableView.automaticDimension
    }
    
    // TODO: Fix cyclomattic complexity
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // Purchase FourSix Pro
                showProPopup(delegate: self)
            } else if indexPath.row == 1 {
                // Restore Purchase of FourSix Pro
                let alert = UIAlertController(title: "Restore FourSix Pro", message: "Would you like to restore your previous purchase of FourSix Pro?", preferredStyle: .alert)
                alert.addAction(cancelAction)
                alert.addAction(UIAlertAction(title: "Restore", style: .default, handler: { _ in
                    IAPManager.shared.restorePurchases { (_, error) in
                        if error != nil {
                            self.showAlert(title: "Error", message: error!)
                        } else {
                            self.showAlert(title: "Restore Successful", message: "...And we're back! Let's get brewing.") {
                                self.purchaseRestored()
                            }
                        }
                    }
                }))
                present(alert, animated: true, completion: nil)
            } else if indexPath.row == 2 {
                // Coffee:Water Ratio
                let actionSheet = UIAlertController(title: "Coffee:Water Ratio", message: "Lower numbers = stronger coffee.", preferredStyle: .actionSheet)
                
                for ratio in ratioArray {
                    actionSheet.addAction(UIAlertAction(title: "1:\(ratio)", style: .default, handler: { [weak self] _ in
                        self?.ratio = ratio
                    }))
                }
                actionSheet.addAction(UIAlertAction(title: "Restore Default", style: .default, handler: { [weak self] _ in
                    self?.ratio = self!.defaultRatio
                }))
                actionSheet.addAction(cancelAction)
                // TODO: Add code for iPad compatibility
//                let cellRect = tableView.rectForRow(at: indexPath)
//                ac.popoverPresentationController?.sourceView = tableView
//                ac.popoverPresentationController?.sourceRect = cellRect
//                ac.popoverPresentationController?.canOverlapSourceViewRect = true
                present(actionSheet, animated: true)
            } else if indexPath.row == 3 {
                // Timer Step Advance
                let actionSheet = UIAlertController(title: "Timer Step Advance", message: nil, preferredStyle: .actionSheet)
                
                for (index, option) in stepAdvanceArray.enumerated() {
                    actionSheet.addAction(UIAlertAction(title: option, style: .default, handler: { [weak self] _ in
                        self?.stepAdvance = index
                        print(index)
                    }))
                }
                actionSheet.addAction(cancelAction)
                present(actionSheet, animated: true)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 3 {
                // Send Feedback
                let alert = UIAlertController(title: "Opening...", message: "Sending you to Twitter to give feedback.", preferredStyle: .alert)
                alert.addAction(cancelAction)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    if let url = URL(string: "https://www.twitter.com/foursixcoffee") {
                        UIApplication.shared.open(url)
                    }
                }))
                present(alert, animated: true)
            } else if indexPath.row == 4 {
                // Rate in the App Store
                var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
                components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
                
                guard let writeReviewURL = components?.url else { return }
                
                UIApplication.shared.open(writeReviewURL)
            } else if indexPath.row == 5 {
                // Share FourSix
                let activityVC = UIActivityViewController(activityItems: [productURL], applicationActivities: nil)
                
                present(activityVC, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            guard let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return nil }
            guard let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { return nil }
            let versionWithBuild = "v\(appVersionString) (\(buildNumber))"
            return versionWithBuild
        } else {
            return nil
        }
    }
    
    // MARK: IBActions
    
    @IBAction func showTotalTimeSwitched(_ sender: UISwitch) {
        if showTotalTimeSwitch.isOn {
            UserDefaultsManager.totalTimeShown = true
        } else {
            UserDefaultsManager.totalTimeShown = false
        }
    }

    // MARK: Navigation Methods
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if UserDefaultsManager.ratio == 0 {
                UserDefaultsManager.ratio = self.defaultRatio
            } else {
                self.delegate?.ratio = UserDefaultsManager.ratio
            }
            if IAPManager.shared.userIsPro() {
                self.delegate?.checkForPro()
            }
        }
    }
}
