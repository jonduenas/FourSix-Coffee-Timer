//
//  SettingsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    //MARK: Constants
    let delegate: BrewVC
    let defaultRatio = 15
    let ratioArray = [12, 13, 14, 15, 16, 17, 18]
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let okActionNoClosure = UIAlertAction(title: "OK", style: .default)
    
    //MARK: Variables
    var ratio = 15 {
        didSet {
            ratioLabel.text = "1:\(ratio)"
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet var showTotalTimeSwitch: UISwitch!
    @IBOutlet var timerAutoAdvanceSwitch: UISwitch!
    @IBOutlet var ratioLabel: UILabel!
    
    
    init?(coder: NSCoder, delegate: BrewVC) {
        self.delegate = delegate
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true

        self.navigationController?.navigationBar.barTintColor = UIColor(named: "Background")
        
        loadUserDefaults()
    }
    
    fileprivate func loadUserDefaults() {
        if UserDefaultsManager.totalTimeShown {
            showTotalTimeSwitch.isOn = true
        } else {
            showTotalTimeSwitch.isOn = false
        }
        
        if UserDefaultsManager.timerAutoAdvance {
            timerAutoAdvanceSwitch.isOn = true
        } else {
            timerAutoAdvanceSwitch.isOn = false
        }
        
        if UserDefaultsManager.ratio != 0 {
            ratio = UserDefaultsManager.ratio
        }
    }
    
    //MARK: TableView Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // Purchase FourSixPro
                let ac = UIAlertController(title: "Purchase FourSix Pro", message: "On release, some features will be available through a one-time in app purchase. These features include adjusting the amount of coffee and water, adjusting the ratio, disabling auto-advance of the timer, and (at a later date) saving each session's details with notes and a rating. For now, you can test these features for free.", preferredStyle: .alert)
                ac.addAction(okActionNoClosure)
                present(ac, animated: true)
            } else if indexPath.row == 1 {
                // Restore Purchase of FourSix Pro
                let ac = UIAlertController(title: "Restore Purchase of FourSix Pro", message: "This is a placeholder for the function of restoring previous in-app purchases.", preferredStyle: .alert)
                ac.addAction(okActionNoClosure)
                present(ac, animated: true)
            } else if indexPath.row == 2 {
                // Coffee:Water Ratio
                let ac = UIAlertController(title: "Coffee:Water Ratio", message: "Lower numbers = stronger coffee.", preferredStyle: .actionSheet)
                
                for ratio in ratioArray {
                    ac.addAction(UIAlertAction(title: "1:\(ratio)", style: .default, handler: { [weak self] _ in
                        self?.ratio = ratio
                        UserDefaultsManager.ratio = ratio
                    }))
                }
                ac.addAction(UIAlertAction(title: "Restore Default", style: .default, handler: { [weak self] _ in
                    self?.ratio = self!.defaultRatio
                    UserDefaultsManager.ratio = self!.defaultRatio
                }))
                ac.addAction(cancelAction)
                present(ac, animated: true)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 3 {
                // Send Feedback
                let ac = UIAlertController(title: "Opening...", message: "Sending you to Twitter to give feedback.", preferredStyle: .alert)
                ac.addAction(cancelAction)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    if let url = URL(string: "https://www.twitter.com/jonduenas") {
                        UIApplication.shared.open(url)
                    }
                }))
                present(ac, animated: true)
            }
        }
    }
    
    @IBAction func showTotalTimeSwitched(_ sender: UISwitch) {
        if showTotalTimeSwitch.isOn {
            UserDefaultsManager.totalTimeShown = true
        } else {
            UserDefaultsManager.totalTimeShown = false
        }
    }
    
    @IBAction func timerAutoAdvanceSwitched(_ sender: Any) {
        let ac = UIAlertController(title: "This feature is not yet functional.", message: nil, preferredStyle: .alert)
        ac.addAction(okActionNoClosure)
        present(ac, animated: true)
    }

    //MARK: Navigation Methods
    
    @IBAction func xTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            if UserDefaultsManager.ratio == 0 {
                UserDefaultsManager.ratio = 15
            } else {
                self?.delegate.ratio = UserDefaultsManager.ratio
            }
        }
    }
    
    
}
