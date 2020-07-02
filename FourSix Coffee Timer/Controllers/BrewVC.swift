//
//  BrewVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class BrewVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var balanceSelect: UISegmentedControl!
    @IBOutlet var strengthSelect: UISegmentedControl!
    
    @IBOutlet var coffeeWaterPicker: UIPickerView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearNavigationBar()
        
        loadUserDefaults()
        
        initializeCoffeeWaterPicker()
    }
    
    fileprivate func initializeCoffeeWaterPicker() {
        coffeeWaterPicker.delegate = self
        coffeeWaterPicker.dataSource = self
        
        coffeeArray = Array(15...30)
        waterArray = coffeeArray.map { $0 * coffeeWaterRatio }
        
        coffeeStringArray = coffeeArray.map(String.init)
        waterStringArray = waterArray.map(String.init)
        
        coffeeWaterPicker.selectRow(selectedCoffeeRow, inComponent: 0, animated: false)
        coffeeWaterPicker.selectRow(selectedWaterRow, inComponent: 1, animated: false)
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
        
        let coffee = Double(coffeeArray[coffeeWaterPicker.selectedRow(inComponent: 0)])
        let totalWater = Double(waterArray[coffeeWaterPicker.selectedRow(inComponent: 1)])
        
        
        calculator.waterPours.removeAll()
        
        calculator.calculate(balance, strength, with: coffee, totalWater)
        
        saveUserDefaults()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coffeeStringArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(coffeeStringArray[row])g"
        } else {
            return "\(waterStringArray[row])g"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.selectRow(row, inComponent: 1, animated: true)
        } else {
            pickerView.selectRow(row, inComponent: 0, animated: true)
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
        defaults.set(coffeeWaterPicker.selectedRow(inComponent: 0), forKey: "selectedCoffee")
        defaults.set(coffeeWaterPicker.selectedRow(inComponent: 1), forKey: "selectedWater")
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
