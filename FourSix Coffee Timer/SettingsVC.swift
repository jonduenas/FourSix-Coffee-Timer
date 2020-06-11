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
    
    var walkthroughEnabled: Bool?
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor(named: "Background")
        
        if let loadedSetting = defaults.object(forKey: "walkthroughEnabled") as? Bool {
            walkthroughEnabled = loadedSetting
            if walkthroughEnabled! {
                walkthroughSwitch.isOn = true
            } else {
                walkthroughSwitch.isOn = false
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                let url = URL(string: "https://www.twitter.com/jonduenas")
                UIApplication.shared.open(url!)
            }
        }
    }

    @IBAction func xTapped(_ sender: Any) {
        self.dismiss(animated: true)
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
