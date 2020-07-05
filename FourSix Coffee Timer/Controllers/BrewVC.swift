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
    
    //MARK: IBOutlets
    @IBOutlet var coffeeLabel: UILabel!
    @IBOutlet var waterLabel: UILabel!
    
    @IBOutlet var balanceSelect: UISegmentedControl!
    @IBOutlet var strengthSelect: UISegmentedControl!
    
    @IBOutlet var slider: TactileSlider!
    
    var calculator = Calculator()
    
    var balance: Balance = .neutral
    var strength: Strength = .medium
    
    var showWalkthrough: Bool?
    
    var recipeCustomizerSelect: RecipeCustomizer = .coffee
    var ratio: Float = 15
    var coffee: Float = 20.0
    var water: Float = 300.0
    
    var coffeeMin: Float = 15
    var coffeeMax: Float = 30
    var waterMin: Float = 225
    var waterMax: Float = 450
    var ratioMin: Float = 12
    var ratioMax: Float = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearNavigationBar()
        
        loadUserDefaults()
        
        coffeeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        waterLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        balanceSelect.setFontMedium()
        strengthSelect.setFontMedium()
        
        updateLabels()
    }
    
    private func initializeSlider() {
        
    }
    
    //MARK: UI Methods
    
    @IBAction func sliderChanged(_ sender: TactileSlider) {
        let currentValue = slider.value
        
        water = currentValue.rounded()
        coffee = (water / ratio).rounded()
        
        updateLabels()
    }
    
    private func updateLabels() {
        coffeeLabel.text = coffee.clean + "g"
        waterLabel.text = water.clean + "g"
    }
    
    private func setSliderMinMax() {
        
    }
    
    private func activateCoffeeSlider() {
        if coffeeMax < coffee {
            coffeeMax = coffee
        }
        if coffeeMin > coffee {
            coffeeMin = coffee
        }

        slider.minimum = coffeeMin
        slider.maximum = coffeeMax
        slider.setValue(coffee.rounded(), animated: false)
    }
    
    private func activateWaterSlider() {
        if waterMax < water {
            waterMax = water
        }
        if waterMin > water {
            waterMin = water
        }

        slider.minimum = waterMin
        slider.maximum = waterMax
        slider.setValue(water.rounded(), animated: false)
    }
    
    private func activateRatioSlider() {
        if ratioMax < ratio {
            ratioMax = ratio
        }
        if ratioMin > ratio {
            ratioMin = ratio
        }
        
        slider.minimum = ratioMin
        slider.maximum = ratioMax
        slider.setValue(ratio.rounded(), animated: false)
    }
    
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
//        let coffee = Double(coffeeArray[coffeePicker.selectedRow(inComponent: 0)])
//        let totalWater = Double(waterArray[waterPicker.selectedRow(inComponent: 0)])
//        let coffee: Double = 20
//        let totalWater: Double = 300
        
        calculator.waterPours.removeAll()
        
        calculator.calculate(balance, strength, with: coffee, water)
        
        saveUserDefaults()
    }
    
    //MARK: Coffee and Water Buttons
    @IBAction func coffeeButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func waterButtonTapped(_ sender: UIButton) {
        
    }
    
    private func showAnimatedView(_ view: UIView) {
        UIView.animate(withDuration: 0.25) {
            view.isHidden = false
        }
    }
    
    private func hideAnimatedView(_ view: UIView) {
        UIView.animate(withDuration: 0.25) {
            view.isHidden = true
        }
    }
    
    private func hideThenShowView(hide hideView: UIView, show showView: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            hideView.isHidden = true
        }) { _ in
            UIView.animate(withDuration: 0.25) {
                showView.isHidden = false
            }
        }
    }
    
    //MARK: Touch Methods
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
    
    
    
    //MARK: Navigation Methods
    
    @IBSegueAction
    func makeRecipeViewController(coder: NSCoder) -> UIViewController? {
        RecipeVC(coder: coder, recipe: calculator.getRecipe())
    }
    
    @IBSegueAction
    func makeSettingsViewController(coder: NSCoder) -> UIViewController? {
        SettingsVC(coder: coder, delegate: self)
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
        
        balance = Balance(rawValue: defaults.float(forKey: "balance")) ?? .neutral
        balanceSelect.selectedSegmentIndex = previousSelectedBalance
        print("\(balance)")
        
        strength = Strength(rawValue: defaults.integer(forKey: "strength")) ?? .medium
        strengthSelect.selectedSegmentIndex = previousSelectedStrength
        print("\(strength)")
        
        //load Show Walkthrough option
        showWalkthrough = defaults.object(forKey: "walkthroughEnabled") as? Bool ?? true
    }
}
