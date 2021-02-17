//
//  SettingsCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/13/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
    let settingsStoryboardName = "Settings"
    
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: BrewCoordinator?
    var navigationController: UINavigationController
    weak var parentVC: SettingsVC?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SettingsVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.coordinator = self
        parentVC = vc
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(vc, animated: false)
    }
    
    func didFinishSettings() {
        parentCoordinator?.didFinishSettings()
        parentCoordinator?.childDidFinish(self)
    }
    
    func showRatioSetting() {
        let child = RatioCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func didFinishSettingRatio() {
        parentVC?.updateRatio()
        navigationController.popViewController(animated: true)
    }
    
    func showCustomIntervalPopup(stepInterval: Int) {
        let vc = CustomIntervalsVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.coordinator = self
        vc.intervalValue = stepInterval
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func didFinishCustomInterval() {
        parentVC?.updateCustomInterval()
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
