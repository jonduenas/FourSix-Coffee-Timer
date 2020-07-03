//
//  BrewVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class BrewVC: UIViewController {

    @IBOutlet var coffeeButton: RoundButtonWithShadow!
    @IBOutlet var waterButton: RoundButtonWithShadow!
    
    @IBOutlet var coffeeWaterRatioSelect: CustomSegmentControl!
    @IBOutlet var balanceSelect: UISegmentedControl!
    @IBOutlet var strengthSelect: UISegmentedControl!
    
    var calculator = Calculator()
    
    var balance: Balance = .neutral
    var strength: Strength = .medium
    
    var showWalkthrough: Bool?
    
    let coffeeWaterRatio = 15
    var coffeeArray = [Int]()
    var waterArray = [Int]()
    var coffeeStringArray = [String]()
    var waterStringArray = [String]()
    var selectedCoffeeRow = 5
    var selectedWaterRow = 5
    
    var coffee: Double = 20
    var water: Double = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearNavigationBar()
        
        loadUserDefaults()
        
        coffeeWaterRatioSelect.setFontLarge()
        balanceSelect.setFontMedium()
        strengthSelect.setFontMedium()
        
        initializeCoffeeWaterButtons()
        
        initializeCoffeeWaterPicker()
    }
    
    fileprivate func initializeCoffeeWaterPicker() {
        
        coffeeArray = Array(15...30)
        waterArray = Array(225...450)
        
        coffeeStringArray = coffeeArray.map(String.init)
        waterStringArray = waterArray.map(String.init)
    }
    
    private func initializeCoffeeWaterButtons() {
        coffeeButton.setTitle(coffee.clean + "g", for: .normal)
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
//        let coffee = Double(coffeeArray[coffeePicker.selectedRow(inComponent: 0)])
//        let totalWater = Double(waterArray[waterPicker.selectedRow(inComponent: 0)])
        let coffee: Double = 20
        let totalWater: Double = 300
        
        calculator.waterPours.removeAll()
        
        calculator.calculate(balance, strength, with: coffee, totalWater)
        
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
        
        balance = Balance(rawValue: defaults.double(forKey: "balance")) ?? .neutral
        balanceSelect.selectedSegmentIndex = previousSelectedBalance
        print("\(balance)")
        
        strength = Strength(rawValue: defaults.integer(forKey: "strength")) ?? .medium
        strengthSelect.selectedSegmentIndex = previousSelectedStrength
        print("\(strength)")
        
        if let previousSelectedCoffeeRow = defaults.object(forKey: "selectedCoffee") as? Int {
            selectedCoffeeRow = previousSelectedCoffeeRow
        }
        
        if let previousSelectedWaterRow = defaults.object(forKey: "selectedWater") as? Int {
            selectedWaterRow = previousSelectedWaterRow
        }
        
        //load Show Walkthrough option
        showWalkthrough = defaults.object(forKey: "walkthroughEnabled") as? Bool ?? true
    }
}
