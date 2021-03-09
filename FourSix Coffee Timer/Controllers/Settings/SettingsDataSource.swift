//
//  SettingsDataSource.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/6/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

enum TableSection: Int, CaseIterable {
    case settings, fourSixProEnabled, fourSixProDisabled, aboutFourSix
}

enum SettingsSectionCell: Int, CaseIterable {
    case showTotalTime
}

enum ProSectionEnabledCell: Int, CaseIterable {
    case ratio, stepAdvance, interval
}

enum ProSectionDisabledCell: Int, CaseIterable {
    case purchasePro, restorePro
}

enum AboutSectionCell: Int, CaseIterable {
    case whatIsFourSix, howTo, faq, feedback, rate, share, acknowledgements
}

enum TableCellIdentifier: String {
    case switchCell = "SwitchCell"
    case detailCell = "DetailCell"
    case basicCell = "BasicCell"
    case ratioCell = "RatioCell"
    case intervalCell = "IntervalCell"
}

class SettingsDataSource: NSObject, UITableViewDataSource {
    private let settingsModel: Settings
    
    let sectionHeaderStrings: [TableSection: String] = [
        .settings: "Settings",
        .fourSixProDisabled: "FourSix Pro",
        .fourSixProEnabled: "FourSix Pro",
        .aboutFourSix: "About FourSix"
    ]
    let settingsSectionStrings: [SettingsSectionCell: String] = [
        .showTotalTime: "Show Total Time Elapsed"
    ]
    
    let proSectionEnabledStrings: [ProSectionEnabledCell: String] = [
        .ratio: "Coffee:Water Ratio",
        .stepAdvance: "Auto Advance Timer",
        .interval: "Timer Step Intervals"
    ]
    
    let proSectionDisabledStrings: [ProSectionDisabledCell: String] = [
        .purchasePro: "Purchase FourSix Pro",
        .restorePro: "Restore Purchase"
    ]
    
    let aboutSectionStrings: [AboutSectionCell: String] = [
        .whatIsFourSix: "What Is FourSix?",
        .howTo: "How Do I Use This App?",
        .faq: "FAQ",
        .feedback: "Send Feedback",
        .rate: "Rate in the App Store",
        .share: "Share FourSix",
        .acknowledgements: "Acknowledgements"
    ]
    
    var shownSections: [TableSection] = [.settings, .fourSixProDisabled, .aboutFourSix]
    
    var userIsPro = false {
        didSet {
            if userIsPro {
                shownSections = [.settings, .fourSixProEnabled, .aboutFourSix]
            } else {
                shownSections = [.settings, .fourSixProDisabled, .aboutFourSix]
            }
        }
    }
    
    var ratio: Float {
        didSet {
            settingsModel.ratio = ratio
        }
    }
    
    var stepInterval: Int {
        didSet {
            settingsModel.stepInterval = stepInterval
        }
    }
    
    var showTotalTime: Bool {
        didSet {
            settingsModel.showTotalTime = showTotalTime
        }
    }
    
    var autoAdvanceTimer: Bool {
        didSet {
            settingsModel.autoAdvanceTimer = autoAdvanceTimer
        }
    }
    
    override init() {
        self.settingsModel = Settings()
        self.ratio = settingsModel.ratio
        self.stepInterval = settingsModel.stepInterval
        self.showTotalTime = settingsModel.showTotalTime
        self.autoAdvanceTimer = settingsModel.autoAdvanceTimer
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return shownSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderStrings[shownSections[section]]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch shownSections[section] {
        case .settings:
            return SettingsSectionCell.allCases.count
        case .fourSixProEnabled:
            return ProSectionEnabledCell.allCases.count
        case .fourSixProDisabled:
            return ProSectionDisabledCell.allCases.count
        case .aboutFourSix:
            return AboutSectionCell.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch shownSections[indexPath.section] {
        case .settings:
            guard let settingsIndex = SettingsSectionCell(rawValue: indexPath.row) else { fatalError("Undefined cell in Settings section")}
            
            switch settingsIndex {
            case .showTotalTime:
                return createTotalTimeCell(for: tableView, indexPath, text: settingsSectionStrings[.showTotalTime])
            }
        case .fourSixProEnabled:
            guard let proIndex = ProSectionEnabledCell(rawValue: indexPath.row) else { fatalError("Undefined cell in Pro section") }
            
            switch proIndex {
            case .ratio:
                return createRatioCell(for: tableView, indexPath)
            case .stepAdvance:
                return createStepAdvanceCell(for: tableView, indexPath)
            case .interval:
                return createIntervalCell(for: tableView, indexPath)
            }
        case .fourSixProDisabled:
            guard let notProIndex = ProSectionDisabledCell(rawValue: indexPath.row) else { fatalError("Undefinied cell in Pro section") }
            return createBasicCell(for: tableView, indexPath, text: proSectionDisabledStrings[notProIndex])
        case .aboutFourSix:
            guard let aboutIndex = AboutSectionCell(rawValue: indexPath.row) else { fatalError("Undefined cell index for About section.") }
            return createBasicCell(for: tableView, indexPath, text: aboutSectionStrings[aboutIndex], showDisclosure: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == shownSections.count - 1 {
            guard let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return nil }
            guard let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { return nil }
            let versionWithBuild = "v\(appVersionString) (\(buildNumber))"
            return versionWithBuild
        } else {
            return nil
        }
    }
    
    @objc func didSwitchTotalTime(_ sender: UISwitch) {
        settingsModel.showTotalTime = sender.isOn
    }
    
    @objc func didSwitchAutoAdvance(_ sender: UISwitch) {
        settingsModel.autoAdvanceTimer = sender.isOn
    }
    
    private func createTotalTimeCell(for tableView: UITableView, _ indexPath: IndexPath, text: String?) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier.switchCell.rawValue, for: indexPath) as? SwitchTableCell else { fatalError("Unable to create SwitchTableCell") }
        cell.cellLabel.text = text
        cell.settingSwitch.isOn = settingsModel.showTotalTime
        cell.settingSwitch.addTarget(self, action: #selector(didSwitchTotalTime(_:)), for: .valueChanged)
        return cell
    }
    
    private func createRatioCell(for tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier.ratioCell.rawValue, for: indexPath) as? RatioCell else { fatalError("Unable to create TextFieldTableCell") }
        cell.cellLabel.text = proSectionEnabledStrings[.ratio]
        cell.cellTextField.text = "1:\(settingsModel.ratio.clean)"
        return cell
    }
    
    private func createStepAdvanceCell(for tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier.switchCell.rawValue, for: indexPath) as? SwitchTableCell else { fatalError("Unable to create SwitchTableCell") }
        cell.cellLabel.text = proSectionEnabledStrings[.stepAdvance]
        cell.settingSwitch.isOn = settingsModel.autoAdvanceTimer
        cell.settingSwitch.addTarget(self, action: #selector(didSwitchAutoAdvance(_:)), for: .valueChanged)
        return cell
    }
    
    private func createIntervalCell(for tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier.intervalCell.rawValue, for: indexPath) as? IntervalCell else { fatalError("Unable to create TextFieldTableCell") }
        cell.cellLabel.text = proSectionEnabledStrings[.interval]
        
        let (minutes, seconds) = settingsModel.stepInterval.convertToMinAndSec()
        
        if minutes == 0 {
            cell.cellTextField.text = "\(seconds) sec"
        } else if seconds == 0 {
            cell.cellTextField.text = "\(minutes) min"
        } else {
            cell.cellTextField.text = "\(minutes) min \(seconds) sec"
        }
        
        return cell
    }
    
    private func createBasicCell(for tableView: UITableView, _ indexPath: IndexPath, text: String?, showDisclosure: Bool = false) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier.basicCell.rawValue, for: indexPath)
        cell.textLabel?.text = text
        
        if showDisclosure {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}
