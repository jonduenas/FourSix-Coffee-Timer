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

    @IBInspectable var addShadow: Bool = false {
        didSet {
            setShadow()
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.25 {
        didSet {
            setShadow()
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 1.5) {
        didSet {
            setShadow()
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 0.5 {
        didSet {
            setShadow()
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

    override func layoutSubviews() {
        super.layoutSubviews()
        setShadow()
    }

    private func createButton() {
        refreshCorners(value: cornerRadius)
    }

    private func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }

    private func refreshBorderColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }

    private func refreshBorderWidth(value: CGFloat) {
        layer.borderWidth = value
    }

    private func setShadow() {
        if addShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = shadowOpacity
            layer.shadowOffset = shadowOffset
            layer.shadowRadius = shadowRadius
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            layer.shadowColor = nil
            layer.shadowPath = nil
            layer.shadowOpacity = 0
        }
    }
}
