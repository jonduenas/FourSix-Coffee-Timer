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
    weak var notesCoordinator: NotesCoordinator?
    weak var timerCoordinator: TimerCoordinator?
    var navigationController: UINavigationController
    var dataManager: DataManager
    var note: NoteMO?
    var isNewNote: Bool = false
    
    init(navigationController: UINavigationController, dataManager: DataManager) {
        self.navigationController = navigationController
        self.dataManager = dataManager
    }
    
    func start() {
        let vc = NoteDetailsVC.instantiate(fromStoryboardNamed: String(describing: NoteDetailsVC.self))
        vc.coordinator = self
        vc.dataManager = dataManager
        vc.isNewNote = isNewNote
        vc.note = note        
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
        notesCoordinator?.childDidFinish(self)
        timerCoordinator?.childDidFinish(self)
        timerCoordinator?.didFinishNewNote()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
