//
//  RecipeBarDetailView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/22/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class BraceView: UIView {
    override class var layerClass: Swift.AnyClass { return CAShapeLayer.self }
    
    lazy var shapeLayer: CAShapeLayer = { self.layer as! CAShapeLayer }()
}

class RecipeBarDetailView: UIView {
    let brace60: BraceView = {
        let view = BraceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.shapeLayer.lineWidth = 3
        view.shapeLayer.lineCap = .round
        view.shapeLayer.fillColor = nil
        return view
    }()
    
    let brace40: BraceView = {
        let view = BraceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.shapeLayer.lineWidth = 3
        view.shapeLayer.lineCap = .round
        view.shapeLayer.fillColor = nil
        return view
    }()
    
    let strengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.baselineAdjustment = .alignCenters
        label.text = "Strength"
        label.font = .italicSystemFont(ofSize: 20)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.baselineAdjustment = .alignCenters
        label.text = "Balance"
        label.font = .italicSystemFont(ofSize: 20)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutBraces()
    }
    
    // Update colors of CAShapeLayers when dark mode toggled
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setBraceColor()
        setNeedsDisplay()
    }
    
    private func commonInit() {
        setBraceColor()
        addSubview(brace60)
        addSubview(strengthLabel)
        addSubview(brace40)
        addSubview(balanceLabel)
    }
    
    private func layoutBraces() {
        let topLeftPoint = CGPoint(x: 10, y: 10)
        let bottom60Point = CGPoint(x: 10, y: frame.maxY * 0.6 - 10)
        let top40Point = CGPoint(x: 12.5, y: frame.height * 0.6 + 10)
        let bottomPoint = CGPoint(x: 12.5, y: frame.height - 10)
        
        brace60.shapeLayer.path = UIBezierPath.brace(from: topLeftPoint, to: bottom60Point).cgPath
        brace40.shapeLayer.path = UIBezierPath.brace(from: top40Point, to: bottomPoint).cgPath
        
        strengthLabel.centerYAnchor.constraint(equalTo: topAnchor, constant: frame.height * 0.3).isActive = true
        strengthLabel.leadingAnchor.constraint(equalTo: brace60.trailingAnchor, constant: 40).isActive = true
        balanceLabel.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -(frame.height * 0.2 - 1)).isActive = true
        balanceLabel.leadingAnchor.constraint(equalTo: brace60.trailingAnchor, constant: 40).isActive = true
    }
    
    private func setBraceColor() {
        brace40.shapeLayer.strokeColor = UIColor.secondaryLabel.cgColor
        brace60.shapeLayer.strokeColor = UIColor.secondaryLabel.cgColor
    }
}
