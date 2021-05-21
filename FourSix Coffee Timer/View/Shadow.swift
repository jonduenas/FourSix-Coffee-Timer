//
//  Shadow.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/5/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class Shadow: UIView {
    @IBInspectable private var cornerRadius: CGFloat = 8
    @IBInspectable var shadowOpacity: Float = 0.25
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 1.5)
    @IBInspectable var shadowRadius: CGFloat = 0.5

    private let shadowLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addShadow()
        layoutShadow()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addShadow()
        layoutShadow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutShadow()
    }

    private func addShadow() {
        layer.cornerRadius = cornerRadius

        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowRadius = shadowRadius

        layer.insertSublayer(shadowLayer, at: 0)
    }

    private func layoutShadow() {
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.shadowPath = shadowLayer.path
    }
}
