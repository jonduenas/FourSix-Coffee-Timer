//
//  RoundedView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/12/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    
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
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            setBorder()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            setBorder()
        }
    }
    
    @IBInspectable var borderAlpha: CGFloat = 0 {
        didSet {
            setBorder()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow(shadow)
    }
    
    private func setBorder() {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.withAlphaComponent(borderAlpha).cgColor
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
