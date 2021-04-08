//
//  CoffeeEditorVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/8/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class CoffeeEditorVC: UIViewController, Storyboarded {

    @IBOutlet weak var roasterTextField: UITextField!
    @IBOutlet weak var coffeeNameTextField: UITextField!
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var roastLevelTextField: UITextField!
    
    weak var coordinator: NotesCoordinator?
    var dataManager: DataManager!
    var coffeeMO: CoffeeMO?
    var coffee: Coffee = Coffee()
    var hasChanges: Bool = false
    var requiredFieldsFilled: Bool {
        coffeeNameTextField.text != "" && roasterTextField.text != ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Coffee"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        
        if coffeeMO != nil {
            showStoredData()
        } else {
            createNewCoffee()
        }
    }
    
    @objc private func didTapDoneButton() {
        guard requiredFieldsFilled else {
            AlertHelper.showAlert(title: "Require Fields", message: "Roaster name and coffee name are required.", on: self)
            return
        }
        
        updateCoffee()
        updateCoffeeMO()
        dataManager.saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancelButton() {
        if hasChanges {
            AlertHelper.showDestructiveAlert(title: "Delete Changes?",
                                             message: nil,
                                             destructiveButtonTitle: "Delete",
                                             dismissButtonTitle: "Cancel",
                                             on: self) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func createNewCoffee() {
        coffeeMO = CoffeeMO(context: dataManager.mainContext)
        updateTextFields()
    }
    
    private func showStoredData() {
        guard let coffeeMO = coffeeMO else { return }
        coffee = Coffee(managedObject: coffeeMO)
        
        updateTextFields()
    }
    
    private func updateTextFields() {
        roasterTextField.text = coffee.roaster
        coffeeNameTextField.text = coffee.name
        originTextField.text = coffee.origin
        roastLevelTextField.text = coffee.roastLevel
    }
    
    private func updateCoffee() {
        coffee.roaster = roasterTextField.text ?? "Error"
        coffee.name = coffeeNameTextField.text ?? "Error"
        coffee.origin = originTextField.text ?? ""
        coffee.roastLevel = roastLevelTextField.text ?? ""
    }
    
    private func updateCoffeeMO() {
        guard let coffeeMO = coffeeMO else { return }
        coffeeMO.name = coffee.name
        coffeeMO.roaster = coffee.roaster
        coffeeMO.origin = coffee.origin
        coffeeMO.roastLevel = coffee.roastLevel
    }
}

extension CoffeeEditorVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hasChanges = true
    }
}
