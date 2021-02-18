//
//  RatioVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/29/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class RatioVC: UITableViewController, Storyboarded {
    private let ratioCellID = "RatioCell"
    private let customRatioText = "Custom Ratio"
    
    lazy var selectedRatio: Int = UserDefaultsManager.ratioSelect {
        didSet {
            UserDefaultsManager.ratioSelect = selectedRatio
            if selectedRatio < Ratio.presets.count {
                ratioValue = Ratio.presets[selectedRatio]
            }
        }
    }
    
    lazy var ratioValue: Ratio = Ratio(consequent: UserDefaultsManager.ratio) {
        didSet {
            UserDefaultsManager.ratio = ratioValue.consequent
        }
    }
    
    weak var delegate: SettingsVC?
    weak var coordinator: RatioCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Default", style: .plain, target: self, action: #selector(restoreDefaultRatio))
    }
    
    @objc func restoreDefaultRatio() {
        guard let defaultRatioIndex = Ratio.presets.firstIndex(of: Ratio.defaultRatio) else {
            showAlert(message: "Error setting default ratio. Try manually setting to 1:15.")
            return
        }
        
        selectedRatio = defaultRatioIndex
        coordinator?.didFinishSettingRatio()
    }
    
    func updateCustomRatio() {
        selectedRatio = Ratio.presets.count
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ratio.presets.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ratioCellID, for: indexPath)
        
        if indexPath.row < Ratio.presets.count {
            cell.textLabel?.text = Ratio.presets[indexPath.row].stringValue
        } else {
            cell.textLabel?.text = customRatioText
        }
        
        cell.accessoryType = indexPath.row == selectedRatio ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < Ratio.presets.count {
            selectedRatio = indexPath.row
            coordinator?.didFinishSettingRatio()
        } else {
            // Open custom ratio popup
            coordinator?.showCustomRatioPopup(ratioValue: ratioValue)
        }
        tableView.reloadData()
    }
}
