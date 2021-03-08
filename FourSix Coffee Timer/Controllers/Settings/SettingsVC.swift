//
//  SettingsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import Purchases

class SettingsVC: UIViewController, PaywallDelegate, Storyboarded {
    
    // MARK: Constants
    private let productURL = URL(string: "https://apps.apple.com/app/id1519905670")!
    private let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    private let okActionNoClosure = UIAlertAction(title: "OK", style: .default)
    private var ratioPickerView: RatioPickerView?
    private var intervalPickerView: IntervalPickerView?
    
    // MARK: Variables
    weak var coordinator: SettingsCoordinator?
    var pickerDataSource = PickerDataSource()
    var settingsDataSource = SettingsDataSource()
    var settingsDelegate = SettingsDelegate()
    var ratio: Float = UserDefaultsManager.ratio {
        didSet {
            //updateRatioText()
            UserDefaultsManager.ratio = ratio
        }
    }

    var userIsPro: Bool = false
    
    // MARK: IBOutlets
//    @IBOutlet weak var showTotalTimeSwitch: UISwitch!
//    @IBOutlet weak var stepAdvanceLabel: UILabel!
//    @IBOutlet weak var ratioTextField: UITextField!
//    @IBOutlet weak var settingsTableView: UITableView!
//    @IBOutlet weak var stepIntervalTextField: UITextField!
//
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavBar()
        tableView.delegate = settingsDelegate
        settingsDelegate.parentController = self
        tableView.dataSource = settingsDataSource
        settingsDataSource.userIsPro = true
        //showTotalTimeSwitch.isOn = UserDefaultsManager.totalTimeShown
        checkForProStatus()
        initIntervalPicker()
        initRatioPicker()
        //updateRatioText()
        //updateIntervalText()
    }
    
    private func initNavBar() {
        title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(closeTapped(_:)))
    }
    
    private func initRatioPicker() {
        ratioPickerView = RatioPickerView(frame: .zero,
                                          dataSource: pickerDataSource,
                                          delegate: self,
                                          toolbarDelegate: self)
        //ratioTextField.inputView = ratioPickerView
        //ratioTextField.inputAccessoryView = ratioPickerView?.toolbar
        
        let currentRatioIndex = pickerDataSource.ratioValueArray.firstIndex(of: Int(ratio)) ?? 14
        ratioPickerView?.selectRow(currentRatioIndex, inComponent: RatioPickerComponent.consequent.rawValue, animated: false)
        
        let currentRatioDecimal = ratio.truncatingRemainder(dividingBy: 1) * 10
        let decimalIndex = pickerDataSource.ratioDecimalValueArray.firstIndex(of: Int(currentRatioDecimal)) ?? 0
        ratioPickerView?.selectRow(decimalIndex, inComponent: RatioPickerComponent.decimalValue.rawValue, animated: false)
    }
    
    private func initIntervalPicker() {
        intervalPickerView = IntervalPickerView(frame: .zero,
                                                dataSource: pickerDataSource,
                                                delegate: self,
                                                toolbarDelegate: self)
        //stepIntervalTextField.inputView = intervalPickerView
        //stepIntervalTextField.inputAccessoryView = intervalPickerView?.toolbar
        
        let (minutes, seconds) = settingsDataSource.stepInterval.convertToMinAndSec()
        let currentMinIndex = pickerDataSource.intervalMin.firstIndex(of: minutes) ?? 0
        let currentSecIndex = pickerDataSource.intervalSec.firstIndex(of: seconds) ?? 0
        
        intervalPickerView?.selectRow(currentMinIndex, inComponent: IntervalPickerComponent.minValue.rawValue, animated: false)
        intervalPickerView?.selectRow(currentSecIndex, inComponent: IntervalPickerComponent.secValue.rawValue, animated: false)
    }
    
//    private func updateIntervalText() {
//        let (minutes, seconds) = stepInterval.convertToMinAndSec()
//
//        if minutes == 0 {
//            stepIntervalTextField.text = "\(seconds) sec"
//        } else if seconds == 0 {
//            stepIntervalTextField.text = "\(minutes) min"
//        } else {
//            stepIntervalTextField.text = "\(minutes) min \(seconds) sec"
//        }
//    }
    
//    private func updateRatioText() {
//        ratioTextField.text = "1:\(ratio.clean)"
//    }
    
    private func checkForProStatus() {
        IAPManager.shared.userIsPro { [weak self] (userIsPro, error) in
            if let err = error {
                self?.showAlert(message: "Error checking for Pro status: \(err.localizedDescription)")
                self?.userIsPro = userIsPro
                self?.enableProFeatures(userIsPro)
            } else {
                self?.userIsPro = userIsPro
                self?.enableProFeatures(userIsPro)
            }
        }
    }
    
    func purchaseCompleted() {
        userIsPro = true
        tableView.reloadData()
    }
    
    func purchaseRestored() {
        userIsPro = true
        tableView.reloadData()
    }
    
    private func enableProFeatures(_ userIsPro: Bool) {
        tableView.reloadData()
    }
    
    // MARK: TableView Methods
    
    
    
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
    
    
    
    // MARK: IBActions
    
//    @IBAction func showTotalTimeSwitched(_ sender: UISwitch) {
//        if showTotalTimeSwitch.isOn {
//            UserDefaultsManager.totalTimeShown = true
//        } else {
//            UserDefaultsManager.totalTimeShown = false
//        }
//    }

    // MARK: Navigation Methods
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.coordinator?.didFinishSettings()
        }
    }
}

extension SettingsVC: SettingsPresenting {
    func selectedCell(row: Int) {
        print("Selected cell: \(row)")
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
            settingsDataSource.stepInterval = (minutes * 60) + seconds
        }
    }
}

extension SettingsVC: ToolBarPickerViewDelegate {
    func didTapDone(_ picker: UIPickerView) {
        if picker == ratioPickerView {
            //ratioTextField.resignFirstResponder()
        } else {
            if settingsDataSource.stepInterval == 0 {
                settingsDataSource.stepInterval += 1
                intervalPickerView?.selectRow(1, inComponent: IntervalPickerComponent.secValue.rawValue, animated: true)
            }
            //stepIntervalTextField.resignFirstResponder()
        }
    }
    
    func didTapDefault(_ picker: UIPickerView) {
        if picker == ratioPickerView {
            guard ratio != Ratio.defaultRatio.consequent else { return }
            guard let defaultRatioIndex = pickerDataSource.ratioValueArray.firstIndex(of: Int(Ratio.defaultRatio.consequent)) else { return }
            print("Set ratio to default")
            ratioPickerView?.selectRow(defaultRatioIndex, inComponent: RatioPickerComponent.consequent.rawValue, animated: true)
            ratioPickerView?.selectRow(0, inComponent: RatioPickerComponent.decimalValue.rawValue, animated: true)
            ratio = Ratio.defaultRatio.consequent
        } else {
            let defaultInterval = Int(Recipe.defaultRecipe.interval)
            guard defaultInterval != settingsDataSource.stepInterval else { return }
            guard let defaultIntervalIndex = pickerDataSource.intervalSec.firstIndex(of: defaultInterval) else { return }
            print("Set interval to default")
            intervalPickerView?.selectRow(0, inComponent: IntervalPickerComponent.minValue.rawValue, animated: true)
            intervalPickerView?.selectRow(defaultIntervalIndex, inComponent: IntervalPickerComponent.secValue.rawValue, animated: true)
            settingsDataSource.stepInterval = defaultInterval
        }
    }
}

//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let section = TableSection(rawValue: indexPath.section)
//
//    switch section {
//    case .fourSixPro:
//        let row = ProSectionCell(rawValue: indexPath.row)
//
//        switch row {
//        case .purchasePro:
//            showProPopup(delegate: self)
//        case .restorePro:
//            showRestoreAlert()
//        case .ratio:
//            ratioTextField.becomeFirstResponder()
//        case .stepAdvance:
//            showStepAdvanceActionSheet(tableView, indexPath)
//        case .interval:
//            stepIntervalTextField.becomeFirstResponder()
//        default:
//            print("Undefined indexPath.row")
//            break
//        }
//    case .aboutFourSix:
//        let row = AboutSectionCell(rawValue: indexPath.row)
//
//        switch row {
//        case .whatIsFourSix:
//            coordinator?.showWhatIs46()
//        case .howTo:
//            coordinator?.showHowTo()
//        case .faq:
//            coordinator?.showFAQ()
//        case .feedback:
//            sendFeedback()
//        case .rate:
//            rateInAppStore()
//        case .share:
//            shareFourSix()
//        case .acknowledgements:
//            coordinator?.showAcknowledgements()
//        default:
//            print("Undefined indexPath.row")
//            break
//        }
//    default:
//        print("Undefined indexPath.section")
//        break
//    }
//    tableView.deselectRow(at: indexPath, animated: true)
//}
