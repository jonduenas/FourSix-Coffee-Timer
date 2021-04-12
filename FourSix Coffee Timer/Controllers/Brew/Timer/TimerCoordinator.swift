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
    
    init(navigationController: UINavigationController, recipe: Recipe) {
        self.navigationController = navigationController
        self.recipe = recipe
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
        vc.recipe = recipe
        vc.session = session
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinishTimer(session: Session, recipe: Recipe) {
        navigationController.dismiss(animated: true, completion: nil)
        parentCoordinator?.didFinishTimer(session: session, recipe: recipe)
        parentCoordinator?.childDidFinish(self)
    }
    
    func didCancelTimer() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinishSummary() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func showNewNote(recipe: Recipe, session: Session) {
        didFinishSummary()
        parentCoordinator?.showNewNote(recipe: recipe, session: session)
    }
}
