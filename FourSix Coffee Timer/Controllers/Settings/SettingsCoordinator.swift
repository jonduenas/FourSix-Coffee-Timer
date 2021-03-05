//
//  SettingsCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/13/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: BrewCoordinator?
    var navigationController: UINavigationController
    weak var parentVC: SettingsVC?
    let settingsStoryboardName = String(describing: SettingsVC.self)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SettingsVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.coordinator = self
        parentVC = vc
        navigationController.pushViewController(vc, animated: false)
    }
    
    func didFinishSettings() {
        parentCoordinator?.didFinishSettings()
        parentCoordinator?.childDidFinish(self)
    }
    
    func showWhatIs46() {
        let vc = WhatIs46VC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showHowTo() {
        let vc = HowToVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFAQ() {
        pushVCWithNoDependencies(viewController: FrequentlyAskedVC())
    }
    
    func showAcknowledgements() {
        pushVCWithNoDependencies(viewController: AcknowledgementsVC())
    }
    
    private func pushVCWithNoDependencies <T: Storyboarded>(viewController: T) where T: UIViewController {
        let vc = T.instantiate(fromStoryboardNamed: settingsStoryboardName)
        navigationController.pushViewController(vc, animated: true)
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
