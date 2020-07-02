//
//  CustomSegmentControl.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/2/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    func fixBackgroundSegmentControl() {
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(self.numberOfSegments-1)  {
                    let backgroundSegmentView = self.subviews[i]
                    backgroundSegmentView.isHidden = true
                }
            }
            selectedSegmentTintColor = UIColor(named: "Highlight")
        }
    }
    
}
