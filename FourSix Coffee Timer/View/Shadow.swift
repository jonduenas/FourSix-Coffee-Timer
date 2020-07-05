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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addShadow()
    }
    
    private func addShadow() {
        layer.cornerRadius = cornerRadius
        
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowLayer.shadowRadius = 1
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
}
