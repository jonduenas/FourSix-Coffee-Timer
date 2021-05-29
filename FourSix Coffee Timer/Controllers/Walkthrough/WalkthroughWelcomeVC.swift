//
//  WalkthroughWelcomeVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/27/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughWelcomeVC: UIViewController, Storyboarded {

    @IBOutlet weak var welcomeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLabel.font = UIFont.newYork(size: 40, weight: .medium)
    }
}
