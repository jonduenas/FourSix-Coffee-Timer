//
//  NotesCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/18/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class NotesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = NotesVC.instantiate(fromStoryboardNamed: String(describing: NotesVC.self))
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(title: "Notes", image: UIImage(systemName: "note.text"), tag: 1)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetails(for note: Note) {
        let vc = NoteDetailsVC.instantiate(fromStoryboardNamed: String(describing: NoteDetailsVC.self))
        vc.coordinator = self
        vc.note = note
        navigationController.pushViewController(vc, animated: true)
    }
}
