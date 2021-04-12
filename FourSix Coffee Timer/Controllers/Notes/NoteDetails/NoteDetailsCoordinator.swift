//
//  NoteDetailsCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/12/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class NoteDetailsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var dataManager: DataManager
    var note: NoteMO?
    var session: Session?
    var recipe: Recipe?
    
    init(navigationController: UINavigationController, dataManager: DataManager) {
        self.navigationController = navigationController
        self.dataManager = dataManager
    }
    
    func start() {
        let vc = NoteDetailsVC.instantiate(fromStoryboardNamed: String(describing: NoteDetailsVC.self))
        vc.coordinator = self
        vc.dataManager = dataManager
        
        if let note = note {
            vc.note = note
        } else {
            // Create new note
            guard let recipe = recipe, let session = session else { return }
            vc.note = dataManager.newNoteMO(session: session, recipe: recipe, coffee: nil)
            vc.isNewNote = true
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showCoffeePicker(currentPicked: CoffeeMO?, dataManager: DataManager, delegate: CoffeePickerDelegate) {
        let vc = CoffeePickerVC.instantiate(fromStoryboardNamed: String(describing: CoffeePickerVC.self))
        vc.coordinator = self
        vc.currentPicked = currentPicked
        vc.delegate = delegate
        vc.dataManager = dataManager
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinishCoffeePicker() {
        navigationController.popViewController(animated: true)
    }
    
    func showCoffeeEditor(coffee: CoffeeMO?, dataManager: DataManager) {
        let vc = CoffeeEditorVC.instantiate(fromStoryboardNamed: String(describing: CoffeeEditorVC.self))
        vc.coffeeMO = coffee
        vc.dataManager = dataManager
        
        let navController = MainNavigationController(rootViewController: vc)
        
        navigationController.present(navController, animated: true, completion: nil)
    }
    
    func didFinishDetails() {
        parentCoordinator?.childDidFinish(self)
    }
}
