//
//  MainTabBarController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/18/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    let dataManager: DataManager
    let brewCoordinator = BrewCoordinator(navigationController: MainNavigationController())
    let notesCoordinator = NotesCoordinator(navigationController: MainNavigationController())
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brewCoordinator.dataManager = dataManager
        notesCoordinator.dataManager = dataManager
        
        brewCoordinator.start()
        notesCoordinator.start()
        
        viewControllers = [brewCoordinator.navigationController, notesCoordinator.navigationController]
        tabBar.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        tabBar.barTintColor = UIColor(named: AssetsColor.background.rawValue)
        tabBar.isTranslucent = false
    }
}
