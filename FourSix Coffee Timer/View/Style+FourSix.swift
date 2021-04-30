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
    case header = "Header"
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

extension UIFont {
    static func newYork(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: size,
                                           weight: weight).fontDescriptor
        
        if let serif = descriptor.withDesign(.serif) {
            return UIFont(descriptor: serif, size: 0.0)
        }
        
        return UIFont(descriptor: descriptor, size: 0.0)
    }
    
    static func newYork(style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        
        if let serifDescriptor = descriptor.withDesign(.serif) {
            let font = UIFont.newYork(size: serifDescriptor.pointSize, weight: weight)
            return metrics.scaledFont(for: font)
        }
        
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
    
    func convertToNewYork() -> UIFont {
        let descriptor = self.fontDescriptor
        if let serif = descriptor.withDesign(.serif) {
            return UIFont(descriptor: serif, size: 0)
        }
        
        return self
    }
}
