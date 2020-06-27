//
//  ViewController+clearNavigationBar.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/27/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

extension UIViewController {
    func clearNavigationBar() {
        //remove shadow from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
}
