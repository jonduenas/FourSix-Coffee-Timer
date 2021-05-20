//
//  Wiggle+UIButton.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/20/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

extension UIButton {
    func wiggle() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = -Double.pi / 16
        animation.fromValue = Double.pi / 16
        animation.duration = 0.1
        animation.repeatCount = 1.5
        animation.autoreverses = true
        layer.add(animation, forKey: "iconShake")
    }
}
