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
    let storyboardName = String(describing: WalkthroughPageVC.self)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = WalkthroughPageVC.instantiate(fromStoryboardNamed: storyboardName)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func getPageViewController() -> CustomPageViewController {
        let pageVC = CustomPageViewController.instantiate(fromStoryboardNamed: storyboardName)
        return pageVC
    }

    func getWalkthroughPages() -> [UIViewController] {
        var pages: [UIViewController] = []

        // Welcome Page
        let welcomePage = WalkthroughWelcomeVC.instantiate(fromStoryboardNamed: storyboardName)
        pages.append(welcomePage)

        // Standard walkthrough pages
        for index in 0...walkthroughModel.headerStrings.count - 1 {
            let page = WalkthroughContentVC.instantiate(fromStoryboardNamed: storyboardName)
            page.headerString = walkthroughModel.headerStrings[index]
            page.footerString = walkthroughModel.footerStrings[index]
            page.walkthroughImageName = walkthroughModel.imageNames[index]
            pages.append(page)
        }

        // Notifications page with button for enabling notifications
        let notificationPage = WalkthroughNotificationsVC.instantiate(fromStoryboardNamed: storyboardName)
        notificationPage.headerString = walkthroughModel.notificationHeaderString
        notificationPage.footerString = walkthroughModel.notificationFooterString
        notificationPage.walkthroughImageName = walkthroughModel.notificationImageName
        pages.append(notificationPage)

        // Final page
        // TODO: Create and add final page to pages

        return pages
    }

    func didFinishWalkthrough() {
        parentCoordinator?.childDidFinish(self)
    }
}
