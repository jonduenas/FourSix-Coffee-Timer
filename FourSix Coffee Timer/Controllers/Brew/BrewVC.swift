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
    weak var coordinator: BrewCoordinator?
    lazy var selectionFeedback = UISelectionFeedbackGenerator()
    lazy var calculator = Calculator()
    var timerStepInterval = Recipe.defaultRecipe.interval
    
    var balance: Balance = Recipe.defaultRecipe.balance {
        didSet {
            UserDefaultsManager.previousSelectedBalance = balance.rawValue
        }
    }

    var strength: Strength = Recipe.defaultRecipe.strength {
        didSet {
            UserDefaultsManager.previousSelectedStrength = strength.rawValue
        }
    }

    var ratio: Ratio = Ratio.defaultRatio {
        didSet {
            if UserDefaultsManager.ratio != ratio.consequent {
                UserDefaultsManager.ratio = ratio.consequent
            }
            calculateWater()
        }
    }
    
    var coffee: Float = Recipe.defaultRecipe.coffee {
        didSet {
            coffeeLabel.text = coffee.clean + "g"
            calculateWater()
        }
    }
    
    var water: Float = Recipe.defaultRecipe.waterTotal {
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
        loadUserDefaults()
        initializeNavBar()
        initializeFonts()
        initializeSlider()
        initializeSelectors()
        checkForPro()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserDefaultsManager.userHasSeenWalkthrough {
            coordinator?.showWalkthrough()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.slider.setValue(self.coffee, animated: true)
        }
    }
    
    private func initializeNavBar() {
        title = "Let's Brew"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(didTapSettings))
    }
    
    private func initializeFonts() {
        coffeeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .bold)
        waterLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .bold)
    }
    
    @objc func didTapSettings() {
        coordinator?.showSettings()
    }
    
    func checkForPro() {
        if IAPManager.shared.userIsPro() {
            enableProFeatures(true)
        } else {
            enableProFeatures(false)
        }
    }
    
    private func initializeSlider() {
        slider.minimum = Recipe.coffeeMin
        slider.maximum = Recipe.coffeeMax
        slider.setValue(Recipe.coffeeMin, animated: false)
    }
    
    private func initializeSelectors() {
        balanceSelect.setFontMedium()
        strengthSelect.setFontMedium()
        
        balanceSelect.selectedSegmentIndex = Balance.allCases.firstIndex(of: balance) ?? 1
        strengthSelect.selectedSegmentIndex = Strength.allCases.firstIndex(of: strength) ?? 1
    }
    
    func purchaseCompleted() {
        checkForPro()
    }
    
    func purchaseRestored() {
        checkForPro()
    }
    
    private func calculateWater() {
        water = (coffee * ratio.consequent).rounded()
    }
    
    private func isCoffeeAcceptableRange() -> Bool {
        return Recipe.acceptableCoffeeRange.contains(coffee)
    }
    
    func updateSettings() {
        ratio = Ratio(consequent: UserDefaultsManager.ratio)
        timerStepInterval = TimeInterval(UserDefaultsManager.timerStepInterval)
        checkForPro()
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
        selectionFeedback.selectionChanged() // Haptic feedback
        balance = Balance.allCases[balanceSelect.selectedSegmentIndex]
    }
    
    @IBAction func strengthChanged(_ sender: Any) {
        selectionFeedback.selectionChanged() // Haptic feedback
        strength = Strength.allCases[strengthSelect.selectedSegmentIndex]
    }

    @IBAction func showRecipeTapped(_ sender: UIButton) {
        let recipe = calculator.calculateRecipe(balance: balance, strength: strength, coffee: coffee, water: water, stepInterval: Double(timerStepInterval))
        coordinator?.showRecipe(recipe: recipe)
    }
    
    @IBAction func calculateTapped(_ sender: Any) {
        if isCoffeeAcceptableRange() {
            let recipe = calculator.calculateRecipe(balance: balance, strength: strength, coffee: coffee, water: water, stepInterval: Double(timerStepInterval))
            coordinator?.showTimer(for: recipe)
        } else {
            if UserDefaultsManager.userHasSeenCoffeeRangeWarning {
                let recipe = calculator.calculateRecipe(balance: balance, strength: strength, coffee: coffee, water: water, stepInterval: Double(timerStepInterval))
                coordinator?.showTimer(for: recipe)
            } else {
                showAlertWithCancel(title: "Warning", message: "The selected amount of coffee is outside the usual amount for this style of brew, and your results may be unexpected. Between 15-25g of coffee is standard. Feel free to go outside that range, but it may take some additional adjustments to get a good tasting cup, and the given preset times may not work well.") { [weak self] in
                    guard let self = self else { return }
                    UserDefaultsManager.userHasSeenCoffeeRangeWarning = true
                    let recipe = self.calculator.calculateRecipe(balance: self.balance, strength: self.strength, coffee: self.coffee, water: self.water, stepInterval: Double(self.timerStepInterval))
                    self.coordinator?.showTimer(for: recipe)
                }
            }
        }
    }
    
    // MARK: UserDefaults
    
    fileprivate func loadUserDefaults() {
        if UserDefaultsManager.launchedBefore {
            balance = Balance(rawValue: UserDefaultsManager.previousSelectedBalance) ?? .neutral
            strength = Strength(rawValue: UserDefaultsManager.previousSelectedStrength) ?? .medium
            timerStepInterval = TimeInterval(UserDefaultsManager.timerStepInterval)
            coffee = UserDefaultsManager.previousCoffee
            ratio = Ratio(consequent: UserDefaultsManager.ratio)
            
            if !UserDefaultsManager.userHasMigratedStepAdvance {
                UserDefaultsManager.timerStepAdvanceSetting = UserDefaultsManager.timerStepAdvance == 1 ? StepAdvance.manual.rawValue : StepAdvance.auto.rawValue
                UserDefaultsManager.userHasMigratedStepAdvance = true
            }
        } else {
            let defaultRecipe = Recipe.defaultRecipe
            UserDefaultsManager.previousSelectedBalance = defaultRecipe.balance.rawValue
            UserDefaultsManager.previousSelectedStrength = defaultRecipe.strength.rawValue
            UserDefaultsManager.timerStepInterval = Int(defaultRecipe.interval)
            UserDefaultsManager.ratio = Ratio.defaultRatio.consequent
            UserDefaultsManager.timerStepAdvanceSetting = StepAdvance.auto.rawValue
            UserDefaultsManager.userHasMigratedStepAdvance = true
            UserDefaultsManager.launchedBefore = true
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
