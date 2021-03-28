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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = NotesVC.instantiate(fromStoryboardNamed: String(describing: NotesVC.self))
        vc.coordinator = self
        vc.coreDataStack = CoreDataStack()
        
        let tabImage: UIImage?
        if #available(iOS 14.0, *) {
            tabImage = UIImage(systemName: "note.text")
        } else {
            tabImage = UIImage(systemName: "square.and.pencil")
        }
        vc.tabBarItem = UITabBarItem(title: "Notes", image: tabImage, tag: 1)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetails(for noteID: NSManagedObjectID, coreDataStack: CoreDataStack) {
        let vc = NoteDetailsVC.instantiate(fromStoryboardNamed: String(describing: NoteDetailsVC.self))
        vc.coordinator = self
        vc.noteID = noteID
        vc.coreDataStack = coreDataStack
        navigationController.pushViewController(vc, animated: true)
    }
}
