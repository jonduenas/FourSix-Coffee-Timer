//
//  NotesCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/18/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import CoreData

class NotesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dataManager: DataManager!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard dataManager != nil else { fatalError("Coordinator requires a DataManager.") }
        
        let vc = NotesVC.instantiate(fromStoryboardNamed: String(describing: NotesVC.self))
        vc.coordinator = self
        vc.dataManager = dataManager
        
        let tabImage: UIImage?
        if #available(iOS 14.0, *) {
            tabImage = UIImage(systemName: "note.text")
        } else {
            tabImage = UIImage(systemName: "square.and.pencil")
        }
        vc.tabBarItem = UITabBarItem(title: "Notes", image: tabImage, tag: 1)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetails(for note: NoteMO, dataManager: DataManager) {
        let vc = NoteDetailsVC.instantiate(fromStoryboardNamed: String(describing: NoteDetailsVC.self))
        vc.notesCoordinator = self
        vc.note = note
        vc.dataManager = dataManager
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showCoffeePicker(currentPicked: CoffeeMO?, dataManager: DataManager, delegate: CoffeePickerDelegate) {
        let vc = CoffeePickerVC.instantiate(fromStoryboardNamed: String(describing: CoffeePickerVC.self))
        vc.notesCoordinator = self
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
}
