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
    weak var delegate: BrewVC?
    
    init(navigationController: UINavigationController, settingsDelegate: BrewVC) {
        self.navigationController = navigationController
        self.delegate = settingsDelegate
    }
    
    func start() {
        let vc = SettingsVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.coordinator = self
        vc.delegate = delegate

        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(vc, animated: false)
    }
    
    func didFinishSettings() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func showRatioSetting(delegate: SettingsVC) {
        let vc = RatioVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.coordinator = self
        vc.delegate = delegate
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showCustomRatioPopup(ratioValue: Float, delegate: RatioVC) {
        let vc = CustomRatioVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.ratioValue = ratioValue
        vc.delegate = delegate
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func showCustomIntervalPopup(stepInterval: Int, delegate: SettingsVC) {
        let vc = CustomIntervalsVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.delegate = delegate
        vc.intervalValue = stepInterval
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func showWhatIs46() {
        let vc = WhatIs46VC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showHowTo() {
        pushVCWithNoDependencies(viewController: HowToVC())
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
}
