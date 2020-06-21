//
//  SettingsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    @IBOutlet var walkthroughSwitch: UISwitch!
    
    weak var delegate: BrewVC!
    
    var walkthroughEnabled: Bool?
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor(named: "Background")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //load saved setting for walkthrough
        walkthroughEnabled = defaults.object(forKey: "walkthroughEnabled") as? Bool ?? true
        
        if walkthroughEnabled! {
            walkthroughSwitch.isOn = true
        } else {
            walkthroughSwitch.isOn = false
        }
        
    }

    //load link in safari if "Send Feedback" cell tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 3 {
                let ac = UIAlertController(title: "Opening...", message: "Sending you to Twitter to give feedback.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    if let url = URL(string: "https://www.twitter.com/jonduenas") {
                        UIApplication.shared.open(url)
                    }
                }))
                present(ac, animated: true)
            }
        }
    }

    @IBAction func xTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            if let walkthroughPref = self?.walkthroughEnabled {
                self?.delegate.updateWalkthroughPreference(to: walkthroughPref)
            }
        }
    }
    
    @IBAction func walkthroughSwitchChanged(_ sender: Any) {
        if walkthroughSwitch.isOn {
            walkthroughEnabled = true
            defaults.set(walkthroughEnabled, forKey: "walkthroughEnabled")
            //print("walkthrough on")
        } else {
            walkthroughEnabled = false
            defaults.set(walkthroughEnabled, forKey: "walkthroughEnabled")
            //print("walkthrough off")
        }
    }
}
