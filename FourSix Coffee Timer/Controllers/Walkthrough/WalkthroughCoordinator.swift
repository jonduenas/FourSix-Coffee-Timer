//
//  WalkthroughCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/21/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: BrewCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = WalkthroughPageVC.instantiate(fromStoryboardNamed: String(describing: WalkthroughPageVC.self))
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func getPageViewController() -> UIPageViewController {
        let pageVC = CustomPageViewController.instantiate(fromStoryboardNamed: String(describing: WalkthroughPageVC.self))
        return pageVC
    }

    func getContentViewController(at index: Int, imageName: String) -> WalkthroughContentVC {
        let contentVC = WalkthroughContentVC.instantiate(fromStoryboardNamed: String(describing: WalkthroughPageVC.self))
        contentVC.index = index
        contentVC.walkthroughImageName = imageName
        return contentVC
    }

    func didFinishWalkthrough() {
        parentCoordinator?.childDidFinish(self)
    }
}
