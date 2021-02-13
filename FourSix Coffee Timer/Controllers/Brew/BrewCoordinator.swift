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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = BrewVC.instantiate(fromStoryboardNamed: "Main")
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showWalkthrough() {
        let vc = WalkthroughPageVC.instantiate(fromStoryboardNamed: "Walkthrough")
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }
}
