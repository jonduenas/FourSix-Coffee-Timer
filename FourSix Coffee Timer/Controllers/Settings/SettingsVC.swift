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
    var settingsDataSource = SettingsDataSource()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavBar()
        tableView.delegate = self
        tableView.dataSource = settingsDataSource
        
        settingsDataSource.userIsPro = true
        checkForProStatus()
    }
    
    private func initNavBar() {
        title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(closeTapped(_:)))
    }
    
    private func checkForProStatus() {
        IAPManager.shared.userIsPro { [weak self] (userIsPro, error) in
            if let err = error {
                self?.showAlert(message: "Error checking for Pro status: \(err.localizedDescription)")
            }
            self?.enableProFeatures(userIsPro)
        }
    }
    
    func purchaseCompleted() {
        enableProFeatures(true)
        tableView.reloadData()
    }
    
    func purchaseRestored() {
        enableProFeatures(true)
        tableView.reloadData()
    }
    
    private func enableProFeatures(_ userIsPro: Bool) {
        settingsDataSource.userIsPro = userIsPro
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

    // MARK: Navigation Methods
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.coordinator?.didFinishSettings()
        }
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settingsDataSource.shownSections[indexPath.section] {
        case .fourSixProEnabled:
            let row = ProSectionEnabledCell(rawValue: indexPath.row)
            
            switch row {
            case .ratio:
                let cell = tableView.cellForRow(at: indexPath) as! RatioCell
                cell.cellTextField.becomeFirstResponder()
            case .interval:
                let cell = tableView.cellForRow(at: indexPath) as! IntervalCell
                cell.cellTextField.becomeFirstResponder()
            default:
                break
            }
        case .fourSixProDisabled:
            let row = ProSectionDisabledCell(rawValue: indexPath.row)
            
            switch row {
            case .purchasePro:
                showProPopup(delegate: self)
            case .restorePro:
                print("restore pro")
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
}
