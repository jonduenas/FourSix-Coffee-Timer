//
//  TimerNavigationController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/19/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class TimerNavigationController: UINavigationController {

    var darkBackground: Bool = false

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkBackground ? .lightContent : .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(didActivate), name: UIScene.didActivateNotification, object: nil)

        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor(named: AssetsColor.background.rawValue)
        navigationBar.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Makes sure app is active before continuing
        //      iOS takes screenshots of both dark and light mode when entering background, which
        //      calls traitCollectionDidChange twice. This guard ensures the rest of the method only
        //      executes when app is currently active.
        guard UIApplication.shared.applicationState == .active else { return }

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            // TimerVC is the only view controller that needs to change status bar style
            guard self.visibleViewController as? TimerVC != nil else { return }

            darkBackground = traitCollection.userInterfaceStyle == .dark
        }
    }

    @objc func didActivate() {
        setNeedsStatusBarAppearanceUpdate()
    }
}
