//
//  BrewCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/12/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class BrewCoordinator: Coordinator {
    let mainStoryboardName = "Main"
    let walkthroughStoryboardName = "Walkthrough"
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = BrewVC.instantiate(fromStoryboardNamed: mainStoryboardName)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showWalkthrough() {
        let vc = WalkthroughPageVC.instantiate(fromStoryboardNamed: walkthroughStoryboardName)
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func showRecipe(recipe: Recipe) {
        let vc = RecipeVC.instantiate(fromStoryboardNamed: mainStoryboardName)
        vc.coordinator = self
        vc.recipe = recipe
        navigationController.pushViewController(vc, animated: true)
    }
}
