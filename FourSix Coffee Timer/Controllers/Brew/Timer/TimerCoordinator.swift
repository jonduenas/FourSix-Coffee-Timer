//
//  TimerCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/19/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class TimerCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: BrewCoordinator?
    var navigationController: UINavigationController
    let recipe: Recipe
    let dataManager: DataManager
    let summaryTransitioningDelegate = SummaryTransitioningDelegate()
    
    init(navigationController: UINavigationController, recipe: Recipe, dataManager: DataManager) {
        self.navigationController = navigationController
        self.recipe = recipe
        self.dataManager = dataManager
    }
    
    func start() {
        let vc = TimerVC.instantiate(fromStoryboardNamed: String(describing: TimerVC.self))
        vc.coordinator = self
        vc.recipe = recipe
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showSummary(recipe: Recipe, session: Session) {
        let vc = BrewSummaryVC.instantiate(fromStoryboardNamed: String(describing: BrewSummaryVC.self))
        vc.coordinator = self
        vc.dataManager = dataManager
        vc.recipe = recipe
        vc.session = session
        vc.transitioningDelegate = summaryTransitioningDelegate
        vc.modalPresentationStyle = .custom
        navigationController.present(vc, animated: true)
    }
    
    func didCancelTimer() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinishSummary() {
        navigationController.dismiss(animated: true) {
            self.parentCoordinator?.childDidFinish(self)
        }
    }
    
    func showNewNote(note: NoteMO?) {
        let child = NoteDetailsCoordinator(navigationController: navigationController, dataManager: dataManager)
        childCoordinators.append(child)
        child.timerCoordinator = self
        child.note = note
        child.isNewNote = true
        child.start()
    }
    
    func didFinishNewNote() {
        parentCoordinator?.childDidFinish(self)
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
