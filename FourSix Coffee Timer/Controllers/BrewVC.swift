//
//  BrewVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import TactileSlider

class BrewVC: UIViewController {
    
    //MARK: Constants
    let balanceDict: [Balance: Int] = [.sweet: 0, .neutral: 1, .bright: 2]
    let strengthDict: [Strength: Int] = [.light: 0, .medium: 1, .strong: 2]
    let coffeeMin: Float = 15
    let coffeeMax: Float = 30
    
    //MARK: Variables
    var didPurchasePro: Bool = true
    var calculator = Calculator()
    var balance: Balance = .neutral
    var strength: Strength = .medium
    
    var ratio: Int = 15 {
        didSet {
            water = (coffee * Float(ratio)).rounded()
        }
    }
    var coffee: Float = 20.0 {
        didSet {
            coffeeLabel.text = coffee.clean + "g"
            calculateWater()
        }
    }
    var water: Float = 300.0 {
        didSet {
            waterLabel.text = water.clean + "g"
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet var coffeeLabel: UILabel!
    @IBOutlet var waterLabel: UILabel!
    
    @IBOutlet var balanceSelect: UISegmentedControl!
    @IBOutlet var strengthSelect: UISegmentedControl!
    
    @IBOutlet var slider: TactileSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearNavigationBar()
        
        loadUserDefaults()
        
        coffeeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        waterLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        
        slider.setValue(coffeeMin, animated: false)
        
        initializeSelectors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserDefaultsManager.userHasSeenWalkthrough {
            if let pageViewController = storyboard?.instantiateViewController(identifier: "Walkthrough") as? WalkthroughPageVC {
                present(pageViewController, animated: true, completion: nil)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.slider.setValue(self.coffee, animated: true)
        }
    }
    
    private func initializeSelectors() {
        balanceSelect.setFontMedium()
        strengthSelect.setFontMedium()
        
        if let balance = balanceDict[balance] {
            print(balance)
            balanceSelect.selectedSegmentIndex = balance
        }
        
        if let strength = strengthDict[strength] {
            print(strength)
            strengthSelect.selectedSegmentIndex = strength
        }
    }
    
    //MARK: UI Methods
    
    @IBAction func sliderChanged(_ sender: TactileSlider) {
        if !didPurchasePro {
            let ac = UIAlertController(title: "Purchase FourSix Pro", message: "Adjusting the amounts requires a purchase of FourSix Pro.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        
        let currentValue = slider.value
        
        coffee = currentValue.rounded()
    }
    
    private func calculateWater() {
        water = (coffee * Float(ratio)).rounded()
    }
    
    @IBAction func balanceChanged(_ sender: Any) {
        if balanceSelect.selectedSegmentIndex == 0 {
            print("Sweet")
            balance = .sweet
            UserDefaultsManager.previousSelectedBalance = balance.rawValue
        } else if balanceSelect.selectedSegmentIndex == 1 {
            print("Neutral")
            balance = .neutral
            UserDefaultsManager.previousSelectedBalance = balance.rawValue
        } else if balanceSelect.selectedSegmentIndex == 2 {
            print("Bright")
            balance = .bright
            UserDefaultsManager.previousSelectedBalance = balance.rawValue
        } else {
            return
        }
    }
    
    @IBAction func strengthChanged(_ sender: Any) {
        if strengthSelect.selectedSegmentIndex == 0 {
            print("Light")
            strength = .light
            UserDefaultsManager.previousSelectedStrength = strength.rawValue
        } else if strengthSelect.selectedSegmentIndex == 1 {
            print("Medium")
            strength = .medium
            UserDefaultsManager.previousSelectedStrength = strength.rawValue
        } else if strengthSelect.selectedSegmentIndex == 2 {
            print("Strong")
            strength = .strong
            UserDefaultsManager.previousSelectedStrength = strength.rawValue
        } else {
            return
        }
    }
    
    @IBAction func calculateTapped(_ sender: Any) {
        calculator.waterPours.removeAll()
        calculator.calculate(balance, strength, with: coffee, water)
    }
    
    //MARK: Navigation Methods
    
    @IBSegueAction
    func makeRecipeViewController(coder: NSCoder) -> UIViewController? {
        RecipeVC(coder: coder, recipe: calculator.getRecipe())
    }
    
    @IBSegueAction
    func makeSettingsViewController(coder: NSCoder) -> UIViewController? {
        SettingsVC(coder: coder, delegate: self)
    }
    
    //MARK: UserDefaults
    
    fileprivate func loadUserDefaults() {
        let rawBalance = UserDefaultsManager.previousSelectedBalance
        balance = Balance(rawValue: rawBalance) ?? .neutral
        print(rawBalance)
        
        let rawStrength = UserDefaultsManager.previousSelectedStrength
        strength = Strength(rawValue: rawStrength) ?? .medium
        print(rawStrength)
        
        
        if UserDefaultsManager.ratio != 0 {
            ratio = UserDefaultsManager.ratio
        }
        
        if UserDefaultsManager.previousCoffee != 0 {
            coffee = UserDefaultsManager.previousCoffee
        }
    }
}
