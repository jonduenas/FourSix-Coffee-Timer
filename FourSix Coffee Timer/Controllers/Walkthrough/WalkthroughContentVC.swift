//
//  WalkthroughContentVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/30/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughContentVC: UIViewController {
    
    @IBOutlet var walkthroughImage: UIImageView!
    @IBOutlet var endLabel: UILabel!
    @IBOutlet var neededToolsStack: UIStackView!
    @IBOutlet var startButton: UIButton!
    
    var walkthroughImageName = ""
    var index = 0
    var isLastPage = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        walkthroughImage.image = UIImage(named: walkthroughImageName)

        if isLastPage {
            showLastPage(true)
        } else {
            showLastPage(false)
        }
    }
    
    private func showLastPage(_ show: Bool) {
        walkthroughImage.isHidden = show
        neededToolsStack.isHidden = !show
        endLabel.isHidden = !show
        startButton.isHidden = !show
    }
    
    @IBAction func startTapped(_ sender: Any) {
        UserDefaultsManager.userHasSeenWalkthrough = true
        self.dismiss(animated: true)
    }
}
