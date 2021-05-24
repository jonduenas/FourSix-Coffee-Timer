//
//  WalkthroughNotificationsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/24/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughNotificationsVC: WalkthroughContentVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text = headerString
        footerLabel.text = footerString
        walkthroughImage.image = UIImage(named: walkthroughImageName)
    }

    @IBAction func didTapEnableNotificationsButton(_ sender: UIButton) {
        print("button working")
    }
}
