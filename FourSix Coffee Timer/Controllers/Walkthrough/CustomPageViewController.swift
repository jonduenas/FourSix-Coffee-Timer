//
//  CustomPageViewController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/30/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class CustomPageViewController: UIPageViewController, Storyboarded {
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
    }

    func style() {
        let appearance = UIPageControl.appearance()
        appearance.currentPageIndicatorTintColor = .systemGray
        appearance.pageIndicatorTintColor = .systemGray4
    }
}
