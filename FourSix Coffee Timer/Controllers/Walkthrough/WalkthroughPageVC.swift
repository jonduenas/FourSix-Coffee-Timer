//
//  WalkthroughPageVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/30/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughPageVC: UIViewController, Storyboarded {
    weak var coordinator: WalkthroughCoordinator?
    var pages: [UIViewController] = []
    var currentViewControllerIndex = 0

    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPages()
        configureNavigationController()
        configurePageViewController()
    }

    private func setupPages() {
        if let pages = coordinator?.getWalkthroughPages() {
            self.pages = pages
        }
    }

    private func configureNavigationController() {
        navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Skip",
            style: .done,
            target: self,
            action: #selector(didTapSkipButton(_:)))
    }

    func configurePageViewController() {
        guard let pageViewController = coordinator?.getPageViewController() else { return }

        pageViewController.dataSource = self

        addChild(pageViewController)
        pageViewController.didMove(toParent: self)

        contentView.addSubview(pageViewController.view)

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            pageViewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            pageViewController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: pageViewController.view.rightAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        guard !pages.isEmpty else { return }
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true)
    }

    @objc func didTapSkipButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            UserDefaultsManager.userHasSeenWalkthrough = true
            self.coordinator?.didFinishWalkthrough()
        }
    }
}

extension WalkthroughPageVC: UIPageViewControllerDataSource {
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        currentViewControllerIndex = currentIndex

        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        currentViewControllerIndex = currentIndex

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
}
