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
        navigationBar.tintColor = UIColor.systemGray
        navigationBar.barTintColor = UIColor(named: AssetsColor.background.rawValue)
        navigationBar.isTranslucent = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishSettings()
    }
}
