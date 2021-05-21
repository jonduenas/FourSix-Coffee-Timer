//
//  SettingsNavigationController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/13/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class SettingsNavigationController: UINavigationController {
    weak var coordinator: SettingsCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        navigationBar.barTintColor = UIColor(named: AssetsColor.header.rawValue)
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.newYork(size: 17, weight: .medium)]
        navigationBar.isTranslucent = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishSettings()
    }
}
