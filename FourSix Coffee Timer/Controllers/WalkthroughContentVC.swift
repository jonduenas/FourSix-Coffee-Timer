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
    @IBOutlet var startButton: UIButton!
    @IBOutlet var questionsButton: UIButton!
    
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
        endLabel.isHidden = !show
        questionsButton.isHidden = !show
        startButton.isHidden = !show
    }
    
    @IBAction func questionsTapped(_ sender: Any) {
        
    }
    
    @IBAction func startTapped(_ sender: Any) {
        UserDefaultsManager.userHasSeenWalkthrough = true
        self.dismiss(animated: true)
    }
}
