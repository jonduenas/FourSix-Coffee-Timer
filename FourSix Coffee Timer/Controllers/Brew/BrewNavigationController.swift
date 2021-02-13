//
//  BrewNavigationController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/12/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class BrewNavigationController: UINavigationController {
    let tintColor = UIColor.systemGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
    }
    
    func setupNavigationBarAppearance() {
        navigationBar.tintColor = tintColor
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
    }
}
