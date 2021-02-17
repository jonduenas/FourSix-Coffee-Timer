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
    private let defaultRatio = 3
    #warning("Change to range")
    private let ratioArray = [12, 13, 14, 15, 16, 17, 18] // FIXME: Change to range
    private let customRatioText = "Custom Ratio"
    
    lazy var selectedRatio: Int = UserDefaultsManager.ratioSelect {
        didSet {
            UserDefaultsManager.ratioSelect = selectedRatio
            if selectedRatio < ratioArray.count {
                ratioValue = Float(ratioArray[selectedRatio])
            }
        }
    }
    
    lazy var ratioValue: Float = UserDefaultsManager.ratio {
        didSet {
            UserDefaultsManager.ratio = ratioValue
            if let delegate = delegate {
                delegate.ratio = ratioValue
                delegate.updateRatio()
            }
        }
    }
    
    weak var delegate: SettingsVC?
    weak var coordinator: RatioCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Default", style: .plain, target: self, action: #selector(restoreDefaultRatio))
    }
    
    @objc func restoreDefaultRatio() {
        selectedRatio = defaultRatio
        navigationController?.popViewController(animated: true)
    }
    
    func updateCustomRatio() {
        selectedRatio = ratioArray.count
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratioArray.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ratioCellID, for: indexPath)
        
        if indexPath.row < ratioArray.count {
            cell.textLabel?.text = "1:\(ratioArray[indexPath.row])"
        } else {
            cell.textLabel?.text = customRatioText
        }
        
        if indexPath.row == selectedRatio {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < ratioArray.count {
            selectedRatio = indexPath.row
            coordinator?.didFinishSettingRatio()
        } else {
            // Open custom ratio popup
            coordinator?.showCustomRatioPopup(ratioValue: ratioValue)
        }
        tableView.reloadData()
    }
}
