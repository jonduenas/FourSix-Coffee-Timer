//
//  AddBackgroundColor+UIStackView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/1/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

extension UIStackView {
    // For fixing background colors not working prior to iOS 14
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
