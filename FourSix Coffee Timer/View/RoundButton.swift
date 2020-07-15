//
//  RoundButton.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    @IBInspectable var borderSize: CGFloat = 0 {
        didSet {
            refreshBorderWidth(value: borderSize)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            refreshBorderColor(borderColor)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createButton()
    }
    
    override func prepareForInterfaceBuilder() {
        createButton()
    }
    
    private func createButton() {
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    func refreshBorderColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }
    
    func refreshBorderWidth(value: CGFloat) {
        layer.borderWidth = value
    }
}
