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
    var walkthroughModel = WalkthroughModel()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = WalkthroughPageVC.instantiate(fromStoryboardNamed: String(describing: WalkthroughPageVC.self))
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func getPageViewController() -> CustomPageViewController {
        let pageVC = CustomPageViewController.instantiate(fromStoryboardNamed: String(describing: WalkthroughPageVC.self))
        return pageVC
    }

    func getWalkthroughPages() -> [UIViewController] {
        var pages: [UIViewController] = []

        for index in 0...walkthroughModel.headerStrings.count - 1 {
            let page = WalkthroughContentVC.instantiate(fromStoryboardNamed: String(describing: WalkthroughPageVC.self))
            page.headerString = walkthroughModel.headerStrings[index]
            page.footerString = walkthroughModel.footerStrings[index]
            page.walkthroughImageName = walkthroughModel.imageNames[index]
            pages.append(page)
        }

        return pages
    }

    func didFinishWalkthrough() {
        parentCoordinator?.childDidFinish(self)
    }
}
