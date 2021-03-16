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

class BrewVC: UIViewController, Storyboarded {
    weak var coordinator: BrewCoordinator?
    lazy var selectionFeedback = UISelectionFeedbackGenerator()
    lazy var calculator = Calculator()
    
    var timerStepInterval: TimeInterval = TimeInterval(UserDefaultsManager.timerStepInterval) {
        didSet {
            UserDefaultsManager.timerStepInterval = Int(timerStepInterval)
        }
    }
    
    var balance: Balance = Balance(rawValue: UserDefaultsManager.previousSelectedBalance) ?? Recipe.defaultRecipe.balance {
        didSet {
            UserDefaultsManager.previousSelectedBalance = balance.rawValue
        }
    }

    var strength: Strength = Strength(rawValue: UserDefaultsManager.previousSelectedStrength) ?? Recipe.defaultRecipe.strength {
        didSet {
            UserDefaultsManager.previousSelectedStrength = strength.rawValue
        }
    }

    var ratio: Ratio = Ratio(consequent: UserDefaultsManager.ratio) {
        didSet {
            if UserDefaultsManager.ratio != ratio.consequent {
                UserDefaultsManager.ratio = ratio.consequent
            }
            water = calculateWater()
        }
    }
    
    var coffee: Float = UserDefaultsManager.previousCoffee {
        didSet {
            water = calculateWater()
        }
    }
    
    lazy var water: Float = calculateWater() {
        didSet {
            updateValueLabels()
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
        checkForStepAdvanceMigration()
        initializeNavBar()
        initializeFonts()
        initializeSlider()
        initializeSelectors()
        checkForProStatus()
        updateValueLabels()
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
    
    private func initializeSlider() {
        slider.minimum = Recipe.coffeeMin
        slider.maximum = Recipe.coffeeMax
        slider.setValue(Recipe.coffeeMin, animated: false)
    }
    
    private func initializeSelectors() {
        balanceSelect.selectedSegmentIndex = Balance.allCases.firstIndex(of: balance) ?? 1
        strengthSelect.selectedSegmentIndex = Strength.allCases.firstIndex(of: strength) ?? 1
    }
    
    private func updateValueLabels() {
        coffeeLabel.text = coffee.clean + "g"
        waterLabel.text = water.clean + "g"
    }
    
    private func calculateWater() -> Float {
        return (coffee * ratio.consequent).rounded()
    }
    
    private func isCoffeeAcceptableRange() -> Bool {
        return Recipe.acceptableCoffeeRange.contains(coffee)
    }
    
    func updateSettings() {
        ratio = Ratio(consequent: UserDefaultsManager.ratio)
        timerStepInterval = TimeInterval(UserDefaultsManager.timerStepInterval)
        checkForProStatus()
    }
    
    private func createRecipe() -> Recipe {
        if UserDefaultsManager.previousCoffee != coffee {
            UserDefaultsManager.previousCoffee = coffee
        }
        
        return calculator.calculateRecipe(balance: balance, strength: strength, coffee: coffee, water: water, stepInterval: timerStepInterval)
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
        coordinator?.showRecipe(recipe: createRecipe())
    }
    
    @IBAction func calculateTapped(_ sender: Any) {
        if isCoffeeAcceptableRange() || UserDefaultsManager.userHasSeenCoffeeRangeWarning {
            coordinator?.showTimer(for: createRecipe())
        } else {
            AlertHelper.showConfirmationAlert(title: "Warning",
                                              message: "The selected amount of coffee is outside the usual amount for this style of brew, and your results may be unexpected. Between 15-25g of coffee is standard. Feel free to go outside that range, but it may take some additional adjustments to get a good tasting cup. Consider adjusting the step interval time.",
                                              confirmButtonTitle: "Continue",
                                              on: self) { [weak self] _ in
                guard let self = self else { return }
                UserDefaultsManager.userHasSeenCoffeeRangeWarning = true
                self.coordinator?.showTimer(for: self.createRecipe())
            }
        }
    }
    
    // MARK: UserDefaults
    
    private func checkForStepAdvanceMigration() {
        if !UserDefaultsManager.userHasMigratedStepAdvance {
            UserDefaultsManager.autoAdvanceTimer = UserDefaultsManager.timerStepAdvance == 0
            UserDefaultsManager.userHasMigratedStepAdvance = true
        }
    }
}

extension BrewVC: PaywallDelegate {
    func purchaseCompleted() {
        enableProFeatures(true)
    }
    
    func purchaseRestored() {
        enableProFeatures(true)
    }
    
    private func checkForProStatus() {
        IAPManager.shared.userIsPro { [weak self] (userIsPro, error) in
            guard let self = self else { return }
            
            if let err = error {
                AlertHelper.showAlert(title: "Unexpected Error", message: "Error checking for Pro status: \(err.localizedDescription)", on: self)
                self.enableProFeatures(userIsPro)
            } else {
                self.enableProFeatures(userIsPro)
            }
        }
    }
    
    private func enableProFeatures(_ userIsPro: Bool) {
        if userIsPro {
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
