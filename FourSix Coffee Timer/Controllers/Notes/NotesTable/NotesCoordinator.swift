//
//  NotesCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/18/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class NotesCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dataManager: DataManager!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard dataManager != nil else { fatalError("Coordinator requires a DataManager.") }
        
        navigationController.delegate = self
        
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
        child.notesCoordinator = self
        childCoordinators.append(child)
        child.note = note
        child.start()
    }
    
    // Checks Navigation Controller if popped View Controller is NoteDetailsVC
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Reads the view controller we're moving from
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller.
        // If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a note details view controller
        if let noteDetailsVC = fromViewController as? NoteDetailsVC {
            // We're popping a note details controller; end its coordinator
            childDidFinish(noteDetailsVC.coordinator)
        }
    }
}
