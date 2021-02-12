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

class BrewVC: UIViewController, PaywallDelegate, Storyboarded {
    
    // MARK: Constants
    let showRecipeID = "ShowRecipe"
    let balanceDict: [Balance: Int] = [.sweet: 0, .neutral: 1, .bright: 2]
    let strengthDict: [Strength: Int] = [.light: 0, .medium: 1, .strong: 2]
    let coffeeMin: Float = 10
    let coffeeMax: Float = 40
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    // MARK: Variables
    var calculator = Calculator()
    var balance: Balance = .neutral
    var strength: Strength = .medium
    var recipe: Recipe?
    var timerStepInterval: Int = 45
    
    var ratio: Float = 15 {
        didSet {
            water = (coffee * ratio).rounded()
        }
    }
    var coffee: Float = 20.0 {
        didSet {
            UserDefaultsManager.previousCoffee = coffee
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
            let walkthroughSB = UIStoryboard(name: "Walkthrough", bundle: Bundle.main)
            if let pageViewController = walkthroughSB.instantiateViewController(identifier: "WalkthroughPageVC") as? WalkthroughPageVC {
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
    
    private func isCoffeeAcceptableRange() -> Bool {
        let acceptableRange: ClosedRange<Float> = 15...25
        return acceptableRange.contains(coffee)
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
        if isCoffeeAcceptableRange() {
            recipe = calculator.calculateRecipe(balance: balance, strength: strength, coffee: coffee, water: water, stepInterval: Double(timerStepInterval))
            performSegue(withIdentifier: showRecipeID, sender: self)
        } else {
            if UserDefaultsManager.userHasSeenCoffeeRangeWarning {
                recipe = calculator.calculateRecipe(balance: balance, strength: strength, coffee: coffee, water: water, stepInterval: Double(timerStepInterval))
                performSegue(withIdentifier: showRecipeID, sender: self)
            } else {
                showAlertWithCancel(title: "Warning", message: "The selected amount of coffee is outside the usual amount for this style of brew, and your results may be unexpected. Between 15-25g of coffee is standard. Feel free to go outside that range, but it may take some additional adjustments to get a good tasting cup, and the given preset times may not work well.") { [weak self] in
                    guard let self = self else { return }
                    UserDefaultsManager.userHasSeenCoffeeRangeWarning = true
                    self.recipe = self.calculator.calculateRecipe(balance: self.balance, strength: self.strength, coffee: self.coffee, water: self.water, stepInterval: Double(self.timerStepInterval))
                    self.performSegue(withIdentifier: self.showRecipeID, sender: self)
                }
            }
        }
    }
    
    // MARK: Navigation Methods
    
    @IBSegueAction
    func makeRecipeViewController(coder: NSCoder) -> UIViewController? {
        guard let recipe = recipe else { return nil }
        return RecipeVC(coder: coder, recipe: recipe)
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
        
        if UserDefaultsManager.timerStepInterval != 0 {
            timerStepInterval = UserDefaultsManager.timerStepInterval
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
