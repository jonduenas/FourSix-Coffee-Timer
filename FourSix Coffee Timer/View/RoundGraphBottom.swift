//
//  RoundGraphBottom.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/2/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

//@IBDesignable
class RoundGraphBottom: UIView {
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }
    
    override func prepareForInterfaceBuilder() {
        createView()
    }
    
    private func createView() {
        self.clipsToBounds = true
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
