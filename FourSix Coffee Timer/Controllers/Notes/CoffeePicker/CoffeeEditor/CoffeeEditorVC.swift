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
    var isNewCoffee: Bool {
        coffeeMO == nil
    }
    var requiredFieldsFilled: Bool {
        coffeeNameTextField.text != "" && roasterTextField.text != ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavController()
        
        if isNewCoffee {
            updateTextFields()
        } else {
            showStoredData()
        }
        
        roasterTextField.becomeFirstResponder()
    }
    
    private func configureNavController() {
        navigationItem.largeTitleDisplayMode = .never
        
        title = isNewCoffee ? "Add Coffee" : "Edit Coffee"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancelButton)
        )
    }
    
    @objc private func didTapDoneButton() {
        guard requiredFieldsFilled else {
            AlertHelper.showAlert(title: "Sorry...", message: "Roaster Name and Coffee Name are required.", on: self)
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
        if isNewCoffee {
            let newCoffee = CoffeeMO(context: dataManager.mainContext)
            newCoffee.name = coffee.name
            newCoffee.roaster = coffee.roaster
            newCoffee.origin = coffee.origin
            newCoffee.roastLevel = coffee.roastLevel
            coffeeMO = newCoffee
            
            do {
                try dataManager.mainContext.obtainPermanentIDs(for: [newCoffee])
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            coffeeMO?.name = coffee.name
            coffeeMO?.roaster = coffee.roaster
            coffeeMO?.origin = coffee.origin
            coffeeMO?.roastLevel = coffee.roastLevel
        }
    }
}

extension CoffeeEditorVC: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if !hasChanges {
            hasChanges = true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !hasChanges {
            hasChanges = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
