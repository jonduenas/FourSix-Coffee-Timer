//
//  RoundButtonWithShadow.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/2/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

//@IBDesignable
class RoundButtonWithShadow: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    private var fillColor: UIColor = UIColor(named: "Highlight")!
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
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
        
        let traitCollection = self.traitCollection
        let resolvedColor = fillColor.resolvedColor(with: traitCollection)
        
        //set the shadow of the view's layer
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = resolvedColor.cgColor
            
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowOffset = CGSize(width: 0, height: 1.0)
            shadowLayer.shadowRadius = 3
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    private func createButton() {
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    //MARK: Update colors on dark mode toggle
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateColors()
        self.setNeedsDisplay()
    }
    
    private func updateColors() {
        self.shadowLayer.fillColor = fillColor.cgColor
    }
}
