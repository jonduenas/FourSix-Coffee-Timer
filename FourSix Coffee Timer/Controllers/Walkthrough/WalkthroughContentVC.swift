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

    var headerString: String = ""
    var walkthroughImageName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text = headerString
        walkthroughImage.image = UIImage(named: walkthroughImageName)
    }

    private func showLastPage(_ show: Bool) {
        walkthroughImage.isHidden = show
//        neededToolsStack.isHidden = !show
//        endLabel.isHidden = !show
//        startButton.isHidden = !show
    }

//    @IBAction func startTapped(_ sender: Any) {
//        UserDefaultsManager.userHasSeenWalkthrough = true
//        self.dismiss(animated: true)
//    }
}
