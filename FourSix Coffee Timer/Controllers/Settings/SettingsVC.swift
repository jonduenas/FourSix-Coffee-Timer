//
//  SettingsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import Purchases

class SettingsVC: UITableViewController, PaywallDelegate, Storyboarded {
    
    // MARK: Constants
    private let defaultRatio: Float = 15.0
    private let stepAdvanceArray = ["Auto", "Manual"]
    private let productURL = URL(string: "https://apps.apple.com/app/id1519905670")!
    private let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    private let okActionNoClosure = UIAlertAction(title: "OK", style: .default)
    
    // MARK: Variables
    weak var delegate: BrewVC?
    weak var coordinator: SettingsCoordinator?
    var ratio: Float = 15 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            if let ratioFormatted = formatter.string(for: ratio) {
                ratioLabel.text = "1:" + ratioFormatted
            }
            UserDefaultsManager.ratio = ratio
        }
    }
    
    var stepAdvance = 0 {
        didSet {
            stepAdvanceLabel.text = stepAdvanceArray[stepAdvance]
            UserDefaultsManager.timerStepAdvance = stepAdvance
        }
    }
    
    var stepInterval = 45 {
        didSet {
            if stepInterval >= 60 {
                let timeInterval = Double(stepInterval)
                stepIntervalLabel.text = timeInterval.stringFromTimeInterval()
            } else {
                stepIntervalLabel.text = "\(stepInterval)s"
            }
            
            UserDefaultsManager.timerStepInterval = stepInterval
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet var showTotalTimeSwitch: UISwitch!
    @IBOutlet var stepAdvanceLabel: UILabel!
    @IBOutlet var ratioLabel: UILabel!
    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet weak var stepIntervalLabel: UILabel!
    
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
        
        if UserDefaultsManager.timerStepInterval != 0 {
            stepInterval = UserDefaultsManager.timerStepInterval
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
    
    func updateRatio() {
        tableView.reloadData()
    }
    
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
            } else if indexPath.row == 4 {
                // Timer Step Interval
                if IAPManager.shared.userIsPro() {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            }
        }
        return UITableView.automaticDimension
    }
    
    fileprivate func showRestoreAlert() {
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
    }
    
    fileprivate func showStepAdvanceActionSheet(_ tableView: UITableView, _ indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: "Timer Step Advance", message: nil, preferredStyle: .actionSheet)
        
        for (index, option) in stepAdvanceArray.enumerated() {
            actionSheet.addAction(UIAlertAction(title: option, style: .default, handler: { [weak self] _ in
                self?.stepAdvance = index
                print(index)
            }))
        }
        actionSheet.addAction(cancelAction)
        
        // Sets where to show popover controller for iPad display
        if let popoverController = actionSheet.popoverPresentationController {
            guard let cellIndexPath = tableView.cellForRow(at: indexPath) else { return }
            popoverController.sourceView = cellIndexPath.contentView
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
            
            popoverController.sourceRect = CGRect(x: cellIndexPath.bounds.maxX - 40, y: cellIndexPath.bounds.maxY, width: 0, height: 0)
        }
        present(actionSheet, animated: true)
    }
    
    fileprivate func sendFeedback() {
        let alert = UIAlertController(title: "Opening...", message: "Sending you to Twitter to give feedback.", preferredStyle: .alert)
        alert.addAction(cancelAction)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let url = URL(string: "https://www.twitter.com/foursixcoffee") {
                UIApplication.shared.open(url)
            }
        }))
        present(alert, animated: true)
    }
    
    fileprivate func rateInAppStore() {
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        
        guard let writeReviewURL = components?.url else { return }
        
        UIApplication.shared.open(writeReviewURL)
    }
    
    fileprivate func shareFourSix() {
        let activityVC = UIActivityViewController(activityItems: [productURL], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            // Purchase FourSix Pro
            showProPopup(delegate: self)
        case (1, 1):
            // Restore Purchase of FourSix Pro
            showRestoreAlert()
        case (1, 2):
            // Coffee:Water Ratio
            coordinator?.showRatioSetting(delegate: self)
        case (1, 3):
            // Timer Step Advance
            showStepAdvanceActionSheet(tableView, indexPath)
        case (1, 4):
            // Timer Step Interval
            coordinator?.showCustomIntervalPopup(stepInterval: stepInterval, delegate: self)
        case (2, 0):
            // What Is FourSix?
            coordinator?.showWhatIs46()
        case (2, 1):
            // How Do I Use This App?
            coordinator?.showHowTo()
        case (2, 2):
            // FAQ
            coordinator?.showFAQ()
        case (2, 3):
            // Send Feedback
            sendFeedback()
        case (2, 4):
            // Rate in the App Store
            rateInAppStore()
        case (2, 5):
            // Share FourSix
            shareFourSix()
        default:
            break
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
            
            if UserDefaultsManager.timerStepInterval == 0 {
                UserDefaultsManager.timerStepInterval = self.stepInterval
            } else {
                self.delegate?.timerStepInterval = UserDefaultsManager.timerStepInterval
            }
            
            if IAPManager.shared.userIsPro() {
                self.delegate?.checkForPro()
            }
        }
    }
}
