//
//  BrewVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import TactileSlider
import Purchases

class BrewVC: UIViewController, PaywallDelegate {
    
    // MARK: Constants
    let balanceDict: [Balance: Int] = [.sweet: 0, .neutral: 1, .bright: 2]
    let strengthDict: [Strength: Int] = [.light: 0, .medium: 1, .strong: 2]
    let coffeeMin: Float = 15
    let coffeeMax: Float = 30
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    // MARK: Variables
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
    
    // MARK: IBOutlets
    @IBOutlet var coffeeLabel: UILabel!
    @IBOutlet var waterLabel: UILabel!
    
    @IBOutlet var balanceSelect: UISegmentedControl!
    @IBOutlet var strengthSelect: UISegmentedControl!
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var slider: TactileSlider!
    @IBOutlet var sliderStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearNavigationBar()
        
        loadUserDefaults()
        
        coffeeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        waterLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        
        initializeSlider()
        initializeSelectors()
        checkForPro()
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
    
    func checkForPro() {
        if IAPManager.shared.userIsPro() {
            enableProFeatures(true)
        } else {
            enableProFeatures(false)
        }
    }
    
    private func initializeSlider() {
        slider.minimum = coffeeMin
        slider.maximum = coffeeMax
        slider.setValue(coffeeMin, animated: false)
    }
    
    private func initializeSelectors() {
        balanceSelect.setFontMedium()
        strengthSelect.setFontMedium()
        
        if let balance = balanceDict[balance] {
            balanceSelect.selectedSegmentIndex = balance
        }
        
        if let strength = strengthDict[strength] {
            strengthSelect.selectedSegmentIndex = strength
        }
    }
    
    func purchaseCompleted() {
        checkForPro()
    }
    
    func purchaseRestored() {
        checkForPro()
    }
    
    private func calculateWater() {
        water = (coffee * Float(ratio)).rounded()
    }
    
    // MARK: IBActions
    
    @IBAction func editTapped(_ sender: UIButton) {
        showProPopup(delegate: self)
    }
    
    @IBAction func sliderChanged(_ sender: TactileSlider) {
        let currentValue = slider.value
        
        coffee = currentValue.rounded()
    }
    
    @IBAction func balanceChanged(_ sender: Any) {
        // Haptic feedback
        selectionFeedback.selectionChanged()
        
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
        // Haptic feedback
        selectionFeedback.selectionChanged()
        
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
    
    // MARK: Navigation Methods
    
    @IBSegueAction
    func makeRecipeViewController(coder: NSCoder) -> UIViewController? {
        RecipeVC(coder: coder, recipe: calculator.getRecipe())
    }
    
    @IBSegueAction
    func makeSettingsViewController(coder: NSCoder) -> UIViewController? {
        SettingsVC(coder: coder, delegate: self)
    }
    
    // MARK: UserDefaults
    
    fileprivate func loadUserDefaults() {
        let rawBalance = UserDefaultsManager.previousSelectedBalance
        balance = Balance(rawValue: rawBalance) ?? .neutral
        
        let rawStrength = UserDefaultsManager.previousSelectedStrength
        strength = Strength(rawValue: rawStrength) ?? .medium
        
        if UserDefaultsManager.ratio != 0 {
            ratio = UserDefaultsManager.ratio
        } else { // Set default ratio value to 15
            ratio = 15
            UserDefaultsManager.ratio = ratio
        }
        
        if UserDefaultsManager.previousCoffee != 0 {
            coffee = UserDefaultsManager.previousCoffee
        }
    }
    
    private func enableProFeatures(_ enable: Bool) {
        if enable {
            editButton.isHidden = true
            UIView.animate(withDuration: 0.25) {
                self.sliderStackView.isHidden = false
            }
        } else {
            editButton.isHidden = false
            sliderStackView.isHidden = true
        }
    }
}
