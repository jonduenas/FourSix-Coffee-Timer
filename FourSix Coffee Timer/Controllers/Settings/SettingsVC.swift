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
    private let productURL = URL(string: "https://apps.apple.com/app/id1519905670")!
    private let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    private let okActionNoClosure = UIAlertAction(title: "OK", style: .default)
    private let ratioPickerView = UIPickerView()
    private let intervalPickerView = UIPickerView()
    
    // MARK: Variables
    weak var coordinator: SettingsCoordinator?
    var pickerDataSource = PickerDataSource()
    var ratio: Float = UserDefaultsManager.ratio {
        didSet {
            updateRatioText()
            UserDefaultsManager.ratio = ratio
        }
    }
    
    var stepAdvance: StepAdvance = StepAdvance(rawValue: UserDefaultsManager.timerStepAdvanceSetting) ?? .auto {
        didSet {
            stepAdvanceLabel.text = stepAdvance.rawValue.capitalized
            UserDefaultsManager.timerStepAdvanceSetting = stepAdvance.rawValue
        }
    }
    
    var stepInterval = UserDefaultsManager.timerStepInterval {
        didSet {
            updateIntervalText()
            UserDefaultsManager.timerStepInterval = stepInterval
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var showTotalTimeSwitch: UISwitch!
    @IBOutlet weak var stepAdvanceLabel: UILabel!
    @IBOutlet weak var ratioTextField: UITextField!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var stepIntervalTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor(named: AssetsColor.background.rawValue)
        
        showTotalTimeSwitch.isOn = UserDefaultsManager.totalTimeShown
        initIntervalPicker()
        initRatioPicker()
        updateRatioText()
        updateIntervalText()
    }
    
    private func initRatioPicker() {
        ratioTextField.inputView = ratioPickerView
        ratioPickerView.delegate = self
        ratioPickerView.dataSource = pickerDataSource
        ratioPickerView.tag = SettingsPicker.ratio.rawValue
        
        let font = UIFont.systemFont(ofSize: 21.0)
        let fontSize: CGFloat = font.pointSize
        let componentWidth: CGFloat = self.view.frame.width / CGFloat(ratioPickerView.numberOfComponents)
        let y = (ratioPickerView.frame.size.height / 2) - (fontSize / 2)

        let label1 = UILabel(frame: CGRect(x: componentWidth * 0.5, y: y, width: componentWidth * 0.4, height: fontSize))
        label1.font = font
        label1.textAlignment = .right
        label1.text = "1  :"
        label1.textColor = UIColor.secondaryLabel
        ratioPickerView.addSubview(label1)
        
        let label2 = UILabel(frame: CGRect(x: componentWidth * 2.5, y: y, width: componentWidth * 0.4, height: fontSize))
        label2.font = font
        label2.textAlignment = .left
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        label2.text = numberFormatter.decimalSeparator
        label2.textColor = UIColor.secondaryLabel
        ratioPickerView.addSubview(label2)
        
        let currentRatioIndex = pickerDataSource.ratioValueArray.firstIndex(of: Int(ratio)) ?? 14
        ratioPickerView.selectRow(currentRatioIndex, inComponent: RatioPickerComponent.consequent.rawValue, animated: false)
        
        let currentRatioDecimal = ratio.truncatingRemainder(dividingBy: 1) * 10
        let decimalIndex = pickerDataSource.ratioDecimalValueArray.firstIndex(of: Int(currentRatioDecimal)) ?? 0
        ratioPickerView.selectRow(decimalIndex, inComponent: RatioPickerComponent.decimalValue.rawValue, animated: false)
    }
    
    private func initIntervalPicker() {
        stepIntervalTextField.inputView = intervalPickerView
        intervalPickerView.delegate = self
        intervalPickerView.dataSource = pickerDataSource
        intervalPickerView.tag = SettingsPicker.interval.rawValue
        
        let font = UIFont.systemFont(ofSize: 20.0)
        let fontSize: CGFloat = font.pointSize
        let componentWidth: CGFloat = self.view.frame.width / CGFloat(intervalPickerView.numberOfComponents)
        let y = (intervalPickerView.frame.size.height / 2) - (fontSize / 2)

        let label1 = UILabel(frame: CGRect(x: componentWidth * 0.65, y: y, width: componentWidth * 0.4, height: fontSize))
        label1.font = font
        label1.textAlignment = .left
        label1.text = "min"
        label1.textColor = UIColor.secondaryLabel
        intervalPickerView.addSubview(label1)
        
        let label2 = UILabel(frame: CGRect(x: componentWidth * 1.65, y: y, width: componentWidth * 0.4, height: fontSize))
        label2.font = font
        label2.textAlignment = .left
        label2.text = "sec"
        label2.textColor = UIColor.secondaryLabel
        intervalPickerView.addSubview(label2)
        
        let (minutes, seconds) = stepInterval.convertToMinAndSec()
        let currentMinIndex = pickerDataSource.intervalMin.firstIndex(of: minutes) ?? 0
        let currentSecIndex = pickerDataSource.intervalSec.firstIndex(of: seconds) ?? 0
        intervalPickerView.selectRow(currentMinIndex, inComponent: IntervalPickerComponent.minValue.rawValue, animated: false)
        intervalPickerView.selectRow(currentSecIndex, inComponent: IntervalPickerComponent.secValue.rawValue, animated: false)
    }
    
    func updateIntervalText() {
        let (minutes, seconds) = stepInterval.convertToMinAndSec()
        
        if minutes == 0 {
            stepIntervalTextField.text = "\(seconds)sec"
        } else if seconds == 0 {
            stepIntervalTextField.text = "\(minutes)min"
        } else {
            stepIntervalTextField.text = "\(minutes)min \(seconds)sec"
        }
    }
    
    func updateRatioText() {
        ratioTextField.text = "1:\(ratio.clean)"
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
        //ratio = Ratio(consequent: UserDefaultsManager.ratio)
        tableView.reloadData()
    }
    
    func updateCustomInterval() {
        stepInterval = UserDefaultsManager.timerStepInterval
        tableView.reloadData()
    }
    
    // Hides cells when user is Pro or not
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSection(rawValue: indexPath.section), section == .fourSixPro else {
            // Makes sure the section is defined and section is FourSix Pro - if not rest of the code doesn't run and just returns auto dimension
            return UITableView.automaticDimension
        }
        
        let row = ProSectionCell(rawValue: indexPath.row)
        
        if IAPManager.shared.userIsPro() {
            switch row {
            case .purchasePro:
                return 0
            case .restorePro:
                return 0.25 // Keeps top border of section
            default:
                return UITableView.automaticDimension
            }
        } else {
            switch row {
            case .ratio, .stepAdvance, .interval:
                return 0
            default:
                return UITableView.automaticDimension
            }
        }
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
                ratioTextField.becomeFirstResponder()
            case .stepAdvance:
                showStepAdvanceActionSheet(tableView, indexPath)
            case .interval:
                stepIntervalTextField.becomeFirstResponder()
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

extension SettingsVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == SettingsPicker.ratio.rawValue {
            let ratioComponent = RatioPickerComponent(rawValue: component)
            
            switch ratioComponent {
            case .consequent:
                return String(pickerDataSource.ratioValueArray[row])
            case .decimalValue:
                return String(pickerDataSource.ratioDecimalValueArray[row])
            default:
                return nil
            }
        } else {
            let intervalComponent = IntervalPickerComponent(rawValue: component)
            
            switch intervalComponent {
            case .minValue:
                return String(pickerDataSource.intervalMin[row])
            case .secValue:
                return String(pickerDataSource.intervalSec[row])
            default:
                return nil
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == SettingsPicker.ratio.rawValue {
            let newRatioValue = Float(pickerDataSource.ratioValueArray[pickerView.selectedRow(inComponent: RatioPickerComponent.consequent.rawValue)])
            let newRatioDecimal = Float(pickerDataSource.ratioDecimalValueArray[pickerView.selectedRow(inComponent: RatioPickerComponent.decimalValue.rawValue)]) * 0.1
            ratio = newRatioValue + newRatioDecimal
        } else {
            let minutes = pickerDataSource.intervalMin[pickerView.selectedRow(inComponent: IntervalPickerComponent.minValue.rawValue)]
            let seconds = pickerDataSource.intervalSec[pickerView.selectedRow(inComponent: IntervalPickerComponent.secValue.rawValue)]
            stepInterval = (minutes * 60) + seconds
        }
    }
}
