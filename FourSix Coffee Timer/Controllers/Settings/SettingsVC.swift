//
//  SettingsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import Purchases

enum StepAdvance: String, CaseIterable {
    case auto, manual
}

class SettingsVC: UITableViewController, PaywallDelegate, Storyboarded {
    
    enum SettingsSection: Int {
        case settings, fourSixPro, aboutFourSix
    }
    
    enum ProSectionCell: Int {
        case purchasePro, restorePro, ratio, stepAdvance, interval
    }
    
    enum AboutSectionCell: Int {
        case whatIsFourSix, howTo, faq, feedback, rate, share, acknowledgements
    }
    
    // MARK: Constants
    private let defaultRatio: Float = 15.0
    private let productURL = URL(string: "https://apps.apple.com/app/id1519905670")!
    private let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    private let okActionNoClosure = UIAlertAction(title: "OK", style: .default)
    
    // MARK: Variables
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
    
    var stepAdvance: StepAdvance = .auto {
        didSet {
            stepAdvanceLabel.text = stepAdvance.rawValue.capitalized
            UserDefaultsManager.timerStepAdvanceSetting = stepAdvance.rawValue
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
        
        if UserDefaultsManager.timerStepAdvanceSetting != "" {
            stepAdvance = StepAdvance(rawValue: UserDefaultsManager.timerStepAdvanceSetting) ?? .auto
        } else {
            UserDefaultsManager.timerStepAdvanceSetting = stepAdvance.rawValue
        }
        
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
        ratio = UserDefaultsManager.ratio
        tableView.reloadData()
    }
    
    func updateCustomInterval() {
        stepInterval = UserDefaultsManager.timerStepInterval
        tableView.reloadData()
    }
    
    // Hides cells when user is Pro or not
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // FIXME: Change to switch and enum
        #warning("Change to switch and enum")
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
        
        for option in StepAdvance.allCases {
            actionSheet.addAction(UIAlertAction(title: option.rawValue.capitalized,
                                                style: .default,
                                                handler: { [weak self] _ in
                self?.stepAdvance = option
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
        let section = SettingsSection(rawValue: indexPath.section)
        
        switch section {
        case .fourSixPro:
            let row = ProSectionCell(rawValue: indexPath.row)
            
            switch row {
            case .purchasePro:
                showProPopup(delegate: self)
            case .restorePro:
                showRestoreAlert()
            case .ratio:
                coordinator?.showRatioSetting()
            case .stepAdvance:
                showStepAdvanceActionSheet(tableView, indexPath)
            case .interval:
                coordinator?.showCustomIntervalPopup(stepInterval: stepInterval)
            default:
                print("Undefined indexPath.row")
                break
            }
        case .aboutFourSix:
            let row = AboutSectionCell(rawValue: indexPath.row)
            
            switch row {
            case .whatIsFourSix:
                coordinator?.showWhatIs46()
            case .howTo:
                coordinator?.showHowTo()
            case .faq:
                coordinator?.showFAQ()
            case .feedback:
                sendFeedback()
            case .rate:
                rateInAppStore()
            case .share:
                shareFourSix()
            case .acknowledgements:
                coordinator?.showAcknowledgements()
            default:
                print("Undefined indexPath.row")
                break
            }
        default:
            print("Undefined indexPath.section")
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
            self?.coordinator?.didFinishSettings()
        }
    }
}
