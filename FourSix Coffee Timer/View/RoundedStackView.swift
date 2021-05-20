//
//  RoundedStackView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/28/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedStackView: UIStackView {

    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }

    @IBInspectable var shadow: Bool = false {
        didSet {
            addShadow(shadow)
        }
    }

    @IBInspectable var roundTopLeft: Bool = false {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }

    @IBInspectable var roundTopright: Bool = false {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }

    @IBInspectable var roundBottomLeft: Bool = false {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }

    @IBInspectable var roundBottomRight: Bool = false {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }

    override func prepareForInterfaceBuilder() {
        initializeView()
    }

    private func initializeView() {
        refreshCorners(value: cornerRadius)
    }

    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value

        layer.maskedCorners = []

        if roundTopLeft {
            layer.maskedCorners.insert(.layerMinXMinYCorner)
        }

        if roundTopright {
            layer.maskedCorners.insert(.layerMaxXMinYCorner)
        }

        if roundBottomLeft {
            layer.maskedCorners.insert(.layerMinXMaxYCorner)
        }

        if roundBottomRight {
            layer.maskedCorners.insert(.layerMaxXMaxYCorner)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow(shadow)
    }

    private func addShadow(_ shouldAddShadow: Bool) {
        if shouldAddShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.2
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowRadius = 1
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            layer.shadowColor = nil
            layer.shadowPath = nil
        }
    }
}
