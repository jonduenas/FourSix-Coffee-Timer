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
    
    func showLearnMore() {
        let vc = WebViewVC()
        vc.urlString = "https://foursixcoffeeapp.com/about/"
        vc.showTitle = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showTipJar() {
        let vc = TipJarVC.instantiate(fromStoryboardNamed: String(describing: TipJarVC.self))
        
        // Checks if screen height can accomodate custom presentation style
        let tipJarTransitioningDelegate = SlideOverTransitioningDelegate()
        tipJarTransitioningDelegate.height = 580
        tipJarTransitioningDelegate.tapToDismiss = true
        
        if UIScreen.main.bounds.height > tipJarTransitioningDelegate.height {
            vc.transitioningDelegate = tipJarTransitioningDelegate
            vc.modalPresentationStyle = .custom
        }
        
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func showAcknowledgements() {
        pushVCWithNoDependencies(viewController: AcknowledgementsVC())
    }
    
    private func pushVCWithNoDependencies <T: Storyboarded>(viewController: T) where T: UIViewController {
        let vc = T.instantiate(fromStoryboardNamed: settingsStoryboardName)
        navigationController.pushViewController(vc, animated: true)
    }
}
