//
//  BrewNavigationController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/12/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class BrewNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
    }
    
    func setupNavigationBarAppearance() {
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.systemGray
        navigationBar.barTintColor = UIColor(named: "Background")
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
    }
}
