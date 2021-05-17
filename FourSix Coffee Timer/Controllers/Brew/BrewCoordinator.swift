//
//  BrewCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/12/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class BrewCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentVC: BrewVC?
    var dataManager: DataManager!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard dataManager != nil else { fatalError("Coordinator requires a DataManager") }
        
        let vc = BrewVC.instantiate(fromStoryboardNamed: String(describing: BrewVC.self))
        vc.coordinator = self
        vc.dataManager = dataManager
        parentVC = vc
        vc.tabBarItem = UITabBarItem(title: "Let's Brew", image: UIImage(systemName: "timer"), tag: 0)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showWalkthrough() {
        let vc = WalkthroughPageVC.instantiate(fromStoryboardNamed: String(describing: WalkthroughPageVC.self))
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func showRecipe(recipe: Recipe) {
        let vc = RecipeVC.instantiate(fromStoryboardNamed: String(describing: RecipeVC.self))
        vc.coordinator = self
        vc.recipe = recipe
        let recipeNav = MainNavigationController(rootViewController: vc)
        navigationController.present(recipeNav, animated: true, completion: nil)
    }
    
    func showSettings() {
        let settingsNav = SettingsNavigationController()
        let child = SettingsCoordinator(navigationController: settingsNav)
        settingsNav.coordinator = child
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
        navigationController.present(child.navigationController, animated: true, completion: nil)
    }
    
    func didFinishSettings() {
        parentVC?.updateSettings()
    }
    
    func showTimer(for recipe: Recipe) {
        let timerNav = TimerNavigationController()
        let childCoordinator = TimerCoordinator(navigationController: timerNav, recipe: recipe, dataManager: dataManager)
        childCoordinators.append(childCoordinator)
        childCoordinator.parentCoordinator = self
        childCoordinator.start()
        navigationController.present(childCoordinator.navigationController, animated: true, completion: nil)
    }
}
