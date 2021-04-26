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
    var dataManager: DataManager!
    var isFirstAppearance: Bool = true
    
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
    @IBOutlet weak var coffeeWaterSlider: UISlider!
    @IBOutlet var sliderStackView: UIStackView!
    @IBOutlet weak var sliderImageViewMin: UIView!
    @IBOutlet weak var sliderImageViewMax: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard dataManager != nil else { fatalError("Controller requires a DataManager.") }
        
        checkForStepAdvanceMigration()
        initializeNavBar()
        initializeFonts()
        initializeSlider()
        initializeSliderButtons()
        initializeSelectors()
        checkForProStatus()
        updateValueLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstAppearance {
            if !UserDefaultsManager.userHasSeenWalkthrough {
                coordinator?.showWalkthrough()
            }
            
            let shouldAnimate = !sliderStackView.isHidden
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.coffeeWaterSlider.setValue(self.coffee, animated: shouldAnimate)
            }
            
            isFirstAppearance = false
        }
    }
    
    private func initializeSliderButtons() {
        let tapGestureMin = UITapGestureRecognizer(target: self, action: #selector(didTapSliderMin(sender:)))
        let tapGestureMax = UITapGestureRecognizer(target: self, action: #selector(didTapSliderMax(sender:)))
        sliderImageViewMin.addGestureRecognizer(tapGestureMin)
        sliderImageViewMax.addGestureRecognizer(tapGestureMax)
    }
    
    @objc private func didTapSliderMin(sender: UIView) {
        guard coffee > Recipe.coffeeMin else { return }
        let currentValue = coffeeWaterSlider.value
        coffeeWaterSlider.setValue(currentValue - 1, animated: true)
        coffee -= 1
        selectionFeedback.selectionChanged()
    }
    
    @objc private func didTapSliderMax(sender: UIView) {
        guard coffee < Recipe.coffeeMax else { return }
        let currentValue = coffeeWaterSlider.value
        coffeeWaterSlider.setValue(currentValue + 1, animated: true)
        coffee += 1
        selectionFeedback.selectionChanged()
    }
    
    private func initializeNavBar() {
        let settingsImage: UIImage?
        if #available(iOS 14.0, *) {
            settingsImage = UIImage(systemName: "gearshape.fill")
        } else {
            settingsImage = UIImage(systemName: "gear")
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(didTapSettings))
        navigationItem.title = "Let's Brew"
        navigationController?.navigationBar.tintColor = UIColor.systemGray
    }
    
    private func initializeFonts() {
        coffeeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .bold)
        waterLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .bold)
    }
    
    @objc func didTapSettings() {
        coordinator?.showSettings()
    }
    
    private func initializeSlider() {
        coffeeWaterSlider.minimumValue = Recipe.coffeeMin
        coffeeWaterSlider.maximumValue = Recipe.coffeeMax
        coffeeWaterSlider.setValue(Recipe.coffeeMin, animated: false)
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
        coordinator?.showProPaywall(delegate: self)
    }
    
    @IBAction func sliderDidChange(_ sender: UISlider) {
        // Rounds the slider value to give "stepped" movement
        sender.setValue(sender.value.rounded(), animated: false)
        
        if coffee != sender.value {
            coffee = sender.value
            selectionFeedback.selectionChanged()
        }
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
