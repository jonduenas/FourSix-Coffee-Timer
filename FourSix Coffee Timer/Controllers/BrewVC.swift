//
//  BrewVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class BrewVC: UIViewController {

    @IBOutlet var balanceSelect: UISegmentedControl!
    @IBOutlet var strengthSelect: UISegmentedControl!
    
    @IBOutlet var calculateButton: UIButton!
    
    var calculator = Calculator()
    
    var balance: Balance = .neutral
    var strength: Strength = .medium
    
    var showWalkthrough: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //remove shadow from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        //round button
        calculateButton.layer.cornerRadius = 25
        
        loadUserDefaults()
    }
    
    //MARK: UI Methods
    
    @IBAction func balanceChanged(_ sender: Any) {
        
        if balanceSelect.selectedSegmentIndex == 0 {
            print("Sweet")
            balance = .sweet
        } else if balanceSelect.selectedSegmentIndex == 1 {
            print("Neutral")
            balance = .neutral
        } else if balanceSelect.selectedSegmentIndex == 2 {
            print("Bright")
            balance = .bright
        } else {
            return
        }
    }
    
    @IBAction func strengthChanged(_ sender: Any) {
        if strengthSelect.selectedSegmentIndex == 0 {
            print("Light")
            strength = .light
        } else if strengthSelect.selectedSegmentIndex == 1 {
            print("Medium")
            strength = .medium
        } else if strengthSelect.selectedSegmentIndex == 2 {
            print("Strong")
            strength = .strong
        } else {
            return
        }
    }
    
    @IBAction func calculateTapped(_ sender: Any) {
        
        let totalWater: Double = 300
        let coffee: Double = 20
        
        calculator.waterPours.removeAll()
        calculator.calculate4(balance, with: coffee, totalWater)
        calculator.calculate6(strength, with: coffee, totalWater)
        
        saveUserDefaults()
        
        if showWalkthrough! {
            showWalkthroughVC()
        } else {
            showTimerVC()
        }
    }
    
    //MARK: Navigation Methods
    
    fileprivate func showWalkthroughVC() {
        //show walkthrough
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Walkthrough") as WalkthroughVC
        
        let nc = UINavigationController(rootViewController: vc)
        
        nc.modalPresentationStyle = .fullScreen
        nc.navigationBar.tintColor = UIColor(named: "Accent")
        
        vc.recipe = calculator.getRecipe()
        vc.recipeWater = calculator.getPours()
        vc.recipeStepCount = calculator.getPours().count
        
        present(nc, animated: true)
    }
    
    fileprivate func showTimerVC() {
        //skip walkthrough
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Timer") as TimerVC
        
        let nc = UINavigationController(rootViewController: vc)
        
        nc.modalPresentationStyle = .fullScreen
        nc.navigationBar.tintColor = UIColor(named: "Accent")
        
        vc.recipe = calculator.getRecipe()
        vc.recipeWater = calculator.getPours()
        
        present(nc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettings" {
            let nc = segue.destination as! UINavigationController
            let vc = nc.viewControllers.first as! SettingsVC
            vc.delegate = self
        }
    }
    
    func updateWalkthroughPreference(to showWalkthrough: Bool) {
        self.showWalkthrough = showWalkthrough
    }
    
    //MARK: UserDefaults Methods
    
    fileprivate func saveUserDefaults() {
        let defaults = UserDefaults.standard
        
        //save current selected recipe
        defaults.set(balance.rawValue, forKey: "balance")
        defaults.set(balanceSelect.selectedSegmentIndex, forKey: "balanceSelect")
        defaults.set(strength.rawValue, forKey: "strength")
        defaults.set(strengthSelect.selectedSegmentIndex, forKey: "strengthSelect")
    }
    
    fileprivate func loadUserDefaults() {
        //load last used recipe
        let defaults = UserDefaults.standard
        
        let previousSelectedBalance = defaults.object(forKey: "balanceSelect") as? Int ?? 1
        let previousSelectedStrength = defaults.object(forKey: "strengthSelect") as? Int ?? 1
        
        balance = Balance(rawValue: defaults.double(forKey: "balance")) ?? .neutral
        balanceSelect.selectedSegmentIndex = previousSelectedBalance
        print("\(balance)")
        
        strength = Strength(rawValue: defaults.integer(forKey: "strength")) ?? .medium
        strengthSelect.selectedSegmentIndex = previousSelectedStrength
        print("\(strength)")
        
        //load Show Walkthrough option
        showWalkthrough = defaults.object(forKey: "walkthroughEnabled") as? Bool ?? true
    }
}
