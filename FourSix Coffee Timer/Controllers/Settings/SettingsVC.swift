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

    @IBOutlet weak var tableView: UITableView!

    weak var coordinator: SettingsCoordinator?
    var settingsDataSource = SettingsDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavBar()
        tableView.delegate = self
        tableView.dataSource = settingsDataSource
        checkForProStatus()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.setToolbarHidden(true, animated: animated)
    }

    private func initNavBar() {
        title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(closeTapped(_:)))
    }

    private func checkForProStatus() {
        IAPManager.shared.userIsPro { [weak self] (userIsPro, error) in
            guard let self = self else { return }

            if let err = error {
                AlertHelper.showAlert(title: "Unexpected Error",
                                      message: "Error checking for Pro status: \(err.localizedDescription)",
                                      on: self)
            }

            self.enableProFeatures(userIsPro)
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
                if let cell = tableView.cellForRow(at: indexPath) as? RatioCell {
                    cell.cellTextField.becomeFirstResponder()
                }
            case .interval:
                if let cell = tableView.cellForRow(at: indexPath) as? IntervalCell {
                    cell.cellTextField.becomeFirstResponder()
                }
            default:
                break
            }
        case .fourSixProDisabled:
            let row = ProSectionDisabledCell(rawValue: indexPath.row)

            switch row {
            case .purchasePro:
                coordinator?.showProPaywall(delegate: self)
            case .restorePro:
                AlertHelper.showRestorePurchaseAlert(on: self) { [weak self] in
                    self?.purchaseRestored()
                }
            default:
                print("Undefined indexPath.row")
            }
        case .aboutFourSix:
            let row = AboutSectionCell(rawValue: indexPath.row)

            switch row {
            case .learnMore:
                coordinator?.showLearnMore()
            case .feedback:
                coordinator?.sendEmail()
            case .tipJar:
                coordinator?.showTipJar()
            case .rate:
                coordinator?.rateInAppStore()
            case .share:
                coordinator?.shareFourSix()
            case .acknowledgements:
                coordinator?.showAcknowledgements()
            default:
                print("Undefined indexPath.row")
            }
        default:
            print("Undefined indexPath.section")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
