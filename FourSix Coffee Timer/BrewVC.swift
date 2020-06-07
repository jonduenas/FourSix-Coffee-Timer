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
    
    var balance = [Double]()
    var strength = [Double]()
    var waterTotal: Double?
    var water40: Double?
    var water60: Double?
    var waterPour1: Double = 0
    var waterPour2: Double = 0
    var water60Pour: Double = 0
    var water60Count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //round button
        startButton.layer.cornerRadius = 25
        
        balanceSelect.selectedSegmentIndex = 1
        
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
            if let water = water40 {
                waterPour1 = round(water * 0.42)
                print("\(waterPour1)")
                
                waterPour2 = water - waterPour1
                print("\(waterPour2)")
            }
        } else if balanceSelect.selectedSegmentIndex == 1 {
            print("Neutral")
            if let water = water40 {
                waterPour1 = round(water * 0.5)
                print("\(waterPour1)")
                
                waterPour2 = water - waterPour1
                print("\(waterPour2)")
            }
        } else if balanceSelect.selectedSegmentIndex == 2 {
            print("Bright")
            if let water = water40 {
                waterPour1 = round(water * 0.58)
                print("\(waterPour1)")
                
                waterPour2 = water - waterPour1
                print("\(waterPour2)")
            }
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
        
        balance.removeAll()
        balance.append(waterPour1)
        balance.append(waterPour2)
        
        strength.removeAll()
        strength.append(contentsOf: repeatElement(water60Pour, count: water60Count))
        
        print(balance)
        print(strength)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Walkthrough") as WalkthroughVC
        
        let nc = UINavigationController(rootViewController: vc)
        
        nc.modalPresentationStyle = .fullScreen
        nc.navigationBar.tintColor = UIColor(named: "Accent")
        
        vc.recipeWater.append(contentsOf: balance)
        vc.recipeWater.append(contentsOf: strength)
        vc.recipeStepCount = balance.count + strength.count
        
        present(nc, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
