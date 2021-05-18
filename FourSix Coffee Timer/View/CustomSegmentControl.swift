//
//  CustomSegmentControl.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/2/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class CustomSegmentControl: UISegmentedControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSegmentControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeSegmentControl()
    }

    func initializeSegmentControl() {
        setTitleTextColor(UIColor.white)
        setTitleTextFont(size: 16, weight: .medium)
    }

    private func setTitleTextColor(_ color: UIColor) {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .selected)
    }

    private func setTitleTextFont(size: CGFloat, weight: UIFont.Weight) {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
}
