//
//  CustomSegmentControl.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/2/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func setFontLarge() {
        let font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
    
    func setFontMedium() {
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
    
        setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
    
    func setFontLargeMonospaced() {
        let font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .semibold)
        
        setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
}

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
        //selectedSegmentTintColor = UIColor(named: "Fill")
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
}
