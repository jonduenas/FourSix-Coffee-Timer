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
    
    @IBOutlet var startButton: UIButton!
    
    var calculator = Calculator()
    //var recipe = Recipe()
    
    var balance: Balance = .neutral
    var strength: Strength = .medium
    
    var waterTotal: Double?
    var water40: Double?
    var water60: Double?
    var waterPour1: Double = 0
    var waterPour2: Double = 0
    var water60Pour: Double = 0
    var water60Count: Int = 0
    
    var showWalkthrough: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //round button
        startButton.layer.cornerRadius = 25
        
        //load last used recipe
        let defaults = UserDefaults.standard
        
        let previousBalance = defaults.object(forKey: "balance") as? Int ?? 1
        let previousStrength = defaults.object(forKey: "strength") as? Int ?? 1
        
        balanceSelect.selectedSegmentIndex = previousBalance
        strengthSelect.selectedSegmentIndex = previousStrength
        
        //load default recipe
        waterTotal = 300
        water40 = waterTotal! * 0.4
        water60 = waterTotal! * 0.6
        waterPour1 = water40! / 2
        waterPour2 = waterPour1
        water60Count = 3
        water60Pour = water60! / Double(water60Count)
        
    }
    
    @IBAction func balanceChanged(_ sender: Any) {
        
        if balanceSelect.selectedSegmentIndex == 0 {
            print("Sweet")
            balance = .sweet
            calculator.calculate4(with: balance)
            
//            if let water = water40 {
//                waterPour1 = round(water * 0.42)
//                print("\(waterPour1)")
//
//                waterPour2 = water - waterPour1
//                print("\(waterPour2)")
//            }
        } else if balanceSelect.selectedSegmentIndex == 1 {
            print("Neutral")
            balance = .neutral
            calculator.calculate4(with: balance)
            
        } else if balanceSelect.selectedSegmentIndex == 2 {
            print("Bright")
            balance = .bright
            calculator.calculate4(with: balance)
        } else {
            return
        }
        
    }
    
    @IBAction func strengthChanged(_ sender: Any) {
        if strengthSelect.selectedSegmentIndex == 0 {
            print("Light")
            if let water = water60 {
                water60Count = 2
                water60Pour = water / Double(water60Count)

                print(water60Pour)
            }
            
        } else if strengthSelect.selectedSegmentIndex == 1 {
            print("Medium")
            if let water = water60 {
                water60Count = 3
                water60Pour = water / Double(water60Count)

                print(water60Pour)
            }
        } else if strengthSelect.selectedSegmentIndex == 2 {
            print("Strong")
            if let water = water60 {
                water60Count = 4
                water60Pour = water / Double(water60Count)

                print(water60Pour)
            }
        } else {
            return
        }
    }
    
    @IBAction func startTapped(_ sender: Any) {
        
//        balance.removeAll()
//        balance.append(waterPour1)
//        balance.append(waterPour2)
//
//        strength.removeAll()
//        strength.append(contentsOf: repeatElement(water60Pour, count: water60Count))
        
        print(balance)
        print(strength)
        
        //load user preferences
        let defaults = UserDefaults.standard
        
        //save current selected recipe
        defaults.set(balanceSelect.selectedSegmentIndex, forKey: "balance")
        defaults.set(strengthSelect.selectedSegmentIndex, forKey: "strength")
        
        //check user setting for showing walkthrough
        showWalkthrough = defaults.object(forKey: "walkthroughEnabled") as? Bool ?? true
        
        if !showWalkthrough! {
            //skip walkthrough
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "Timer") as TimerVC
            
            let nc = UINavigationController(rootViewController: vc)
            
            nc.modalPresentationStyle = .fullScreen
            nc.navigationBar.tintColor = UIColor(named: "Accent")
            
//            vc.recipeWater.append(contentsOf: balance)
//            vc.recipeWater.append(contentsOf: strength)
            if let waterTotal = waterTotal {
                vc.totalWater = waterTotal
            }
            
            present(nc, animated: true)
        } else {
            //show walkthrough
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "Walkthrough") as WalkthroughVC
            
            let nc = UINavigationController(rootViewController: vc)
            
            nc.modalPresentationStyle = .fullScreen
            nc.navigationBar.tintColor = UIColor(named: "Accent")
            
//            vc.recipeWater.append(contentsOf: balance)
//            vc.recipeWater.append(contentsOf: strength)
//            vc.recipeStepCount = balance.count + strength.count
            
            present(nc, animated: true)
            
        }
    }
}
