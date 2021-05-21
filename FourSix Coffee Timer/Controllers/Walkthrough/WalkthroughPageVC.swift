//
//  WalkthroughPageVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/30/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughPageVC: UIViewController, Storyboarded {
    let walkthroughImageNames = ["walkthrough-1", "walkthrough-2", "walkthrough-3", "walkthrough-4", "walkthrough-4"]

    var currentViewControllerIndex = 0
    weak var coordinator: BrewCoordinator?

    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configurePageViewController()
    }

    func configurePageViewController() {
        guard let pageViewController = coordinator?.getPageViewController() as? CustomPageViewController else {
            return
        }

        pageViewController.delegate = self
        pageViewController.dataSource = self

        addChild(pageViewController)
        pageViewController.didMove(toParent: self)

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(pageViewController.view)

        let constraints = [
            pageViewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            pageViewController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: pageViewController.view.rightAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        guard let startingViewController = contentViewControllerAt(index: currentViewControllerIndex) else { return }

        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }

    func contentViewControllerAt(index: Int) -> WalkthroughContentVC? {
        if index >= walkthroughImageNames.count || walkthroughImageNames.count == 0 {
            return nil
        }

        guard let contentViewController = storyboard?.instantiateViewController(
                withIdentifier: String(describing: WalkthroughContentVC.self))
                as? WalkthroughContentVC else {
            return nil
        }

        contentViewController.index = index
        contentViewController.walkthroughImageName = walkthroughImageNames[index]

        if index == walkthroughImageNames.count - 1 {
            // Last page
            contentViewController.isLastPage = true
        }

        return contentViewController
    }
    @IBAction func skipTapped(_ sender: Any) {
        UserDefaultsManager.userHasSeenWalkthrough = true
        self.dismiss(animated: true)
    }
}

extension WalkthroughPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return walkthroughImageNames.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as? WalkthroughContentVC

        guard var currentIndex = contentViewController?.index else { return nil }

        currentViewControllerIndex = currentIndex

        if currentIndex == 0 {
            return nil
        }

        currentIndex -= 1

        return contentViewControllerAt(index: currentIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as? WalkthroughContentVC

        guard var currentIndex = contentViewController?.index else { return nil }

        if currentIndex == walkthroughImageNames.count - 1 {
            return nil
        }

        currentIndex += 1

        currentViewControllerIndex = currentIndex

        return contentViewControllerAt(index: currentIndex)
    }
}
