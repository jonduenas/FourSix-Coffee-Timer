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
    @IBOutlet var startButton: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    
    var walkthroughImageName = ""
    var index = 0
//    var startIsHidden = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.currentPage = index
        
        walkthroughImage.image = UIImage(named: walkthroughImageName)

//        if startIsHidden {
//            startButton.isHidden = true
//        } else {
//            startButton.isHidden = false
//        }
    }
}
