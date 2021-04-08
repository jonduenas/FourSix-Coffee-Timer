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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Coffee"
        
        if coffeeMO != nil {
            showStoredData()
        }
    }
    
    private func showStoredData() {
        guard let coffee = coffeeMO else { return }
        
        roasterTextField.text = coffee.roaster
        coffeeNameTextField.text = coffee.name
        originTextField.text = coffee.origin
        roastLevelTextField.text = coffee.roastLevel
    }
    
    private func updateCoffee(with textField: UITextField) {
        guard let coffee = coffeeMO else { return }
        
        let text = textField.text ?? ""
        
        switch textField {
        case roasterTextField:
            if text == "" {
                AlertHelper.showConfirmationAlert(title: "Required Field",
                                                  message: "A roaster name is required.",
                                                  confirmButtonTitle: "OK",
                                                  on: self) { _ in
                    textField.becomeFirstResponder()
                }
            } else {
                coffee.roaster = text
                dataManager.saveContext()
            }
        case coffeeNameTextField:
            if text == "" {
                AlertHelper.showConfirmationAlert(title: "Required Field",
                                                  message: "A coffee name is required.",
                                                  confirmButtonTitle: "OK",
                                                  on: self) { _ in
                    textField.becomeFirstResponder()
                }
            } else {
                coffee.name = text
                dataManager.saveContext()
            }
        case originTextField:
            coffee.origin = text
        case roastLevelTextField:
            coffee.origin = text
        default:
            return
        }
    }
}

extension CoffeeEditorVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard reason == .committed else { return }
        
        updateCoffee(with: textField)
    }
}
