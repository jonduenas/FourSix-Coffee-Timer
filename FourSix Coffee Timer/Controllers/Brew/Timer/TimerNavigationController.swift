//
//  TimerNavigationController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/19/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class TimerNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor(named: AssetsColor.background.rawValue)
        navigationBar.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
    }
}
