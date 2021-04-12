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
        let child = NoteDetailsCoordinator(navigationController: navigationController, dataManager: dataManager)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.note = note
        child.start()
    }
}
