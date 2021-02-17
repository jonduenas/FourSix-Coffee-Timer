//
//  RatioCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/17/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class RatioCoordinator: Coordinator {
    let settingsStoryboardName = "Settings"
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: SettingsCoordinator?
    weak var parentVC: RatioVC?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = RatioVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.coordinator = self
        parentVC = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinishSettingRatio() {
        parentCoordinator?.didFinishSettingRatio()
        parentCoordinator?.childDidFinish(self)
    }
    
    func showCustomRatioPopup(ratioValue: Float) {
        let vc = CustomRatioVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.ratioValue = ratioValue
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func didFinishCustomRatio() {
        parentVC?.updateCustomRatio()
        didFinishSettingRatio()
    }
}
