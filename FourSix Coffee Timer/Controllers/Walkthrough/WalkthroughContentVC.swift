//
//  WalkthroughContentVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/30/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughContentVC: UIViewController, Storyboarded {

    @IBOutlet weak var walkthroughImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!

    var headerString: String = ""
    var footerString: String = ""
    var walkthroughImageName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text = headerString
        footerLabel.text = footerString
        walkthroughImage.image = UIImage(named: walkthroughImageName)?.rounded(radius: 20)
    }
}
