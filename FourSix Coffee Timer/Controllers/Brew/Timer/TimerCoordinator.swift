//
//  TimerCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/19/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class TimerCoordinator: Coordinator {
    let mainStoryboardName = "Main"
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: BrewCoordinator?
    var navigationController: UINavigationController
    let recipe: Recipe
    
    init(navigationController: UINavigationController, recipe: Recipe) {
        self.navigationController = navigationController
        self.recipe = recipe
    }
    
    func start() {
        let vc = TimerVC.instantiate(fromStoryboardNamed: mainStoryboardName)
        vc.coordinator = self
        vc.recipe = recipe
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showSummary(recipe: Recipe, drawdownTimes: [TimeInterval], totalTime: TimeInterval) {
        let vc = BrewSummaryVC.instantiate(fromStoryboardNamed: mainStoryboardName)
        vc.coordinator = self
        vc.recipe = recipe
        vc.drawdownTimes = drawdownTimes
        vc.totalTime = totalTime
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didCancelTimer() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinishSummary() {
        parentCoordinator?.childDidFinish(self)
    }
}
