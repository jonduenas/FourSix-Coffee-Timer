//
//  MainNavigationController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/12/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
    }
    
    func setupNavigationBarAppearance() {
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        navigationBar.barTintColor = UIColor(named: AssetsColor.background.rawValue)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
    }
}

extension UINavigationController {
    func hideBarShadow(_ shouldHide: Bool) {
        navigationBar.shadowImage = shouldHide ? UIImage() : nil
    }
}
