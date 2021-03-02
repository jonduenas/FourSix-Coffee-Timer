//
//  Style+FourSix.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/2/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

enum AssetsColor: String {
    case background = "Background"
    case accent = "Accent"
    case fill = "Fill"
    case highlight = "Highlight"
    case primary = "Primary"
    case secondaryBackground = "SecondaryBackground"
    case sliderBackground = "SliderBackground"
    case fourSixBlue
    case fourSixWhite
}

extension UIColor {
    static var fourSixBlue: UIColor? {
        return UIColor(named: AssetsColor.fourSixBlue.rawValue)
    }
    
    static var fourSixWhite: UIColor? {
        return UIColor(named: AssetsColor.fourSixWhite.rawValue)
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }
    
    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            if b < 1.0 {
                let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0.0)
                return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
            } else {
                let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
                return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
            }
        }
        return self
    }
    
    static func barChartColors() -> [UIColor?] {
        let brightestColor = UIColor.fourSixBlue?.lighter(by: 24)
        var colorArray = [brightestColor]
        
        var currentColor = brightestColor
        
        for _ in 1...5 {
            currentColor = currentColor?.darker(by: 8)
            colorArray.append(currentColor)
        }
        
        return colorArray
    }
}
