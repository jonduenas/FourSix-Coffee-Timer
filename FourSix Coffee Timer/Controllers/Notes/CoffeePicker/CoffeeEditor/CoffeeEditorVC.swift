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
}
