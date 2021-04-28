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
        navigationBar.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: AssetsColor.header.rawValue)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: AssetsColor.accent.rawValue) ?? UIColor.systemYellow]
        appearance.buttonAppearance = buttonAppearance
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}

extension UINavigationController {
    func hideBarShadow(_ shouldHide: Bool) {
        navigationBar.shadowImage = shouldHide ? UIImage() : nil
    }
}
