//
//  CustomSlider.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/3/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

// These are out self-defined rules for how we will communicate with other classes
protocol ViewControllerCommunicationDelegate: class {
    func myTrackingBegan()
    func myTrackingContinuing(location: CGPoint)
    func myTrackingEnded()
}

class CustomSlider: UIControl {
    
    weak var delegate: ViewControllerCommunicationDelegate?

    private let cornerRadius: CGFloat = 8

    // color constants
    private let trackColor = UIColor(named: "Highlight")!
    private let accentColor = UIColor(named: "Accent")!
    
    // CAShapelayers
    private let trackLayer = CAShapeLayer()
    private let fillLayer = CAShapeLayer()
    private let maskLayer = CAShapeLayer()
    
    @IBInspectable private var minValue: CGFloat = 0 {
        didSet {
            if maxValue < minValue {
                maxValue = minValue
            }
            if currentValue < minValue {
                currentValue = minValue
            }
            updateValues()
            
        }
    }
    
    @IBInspectable private var maxValue: CGFloat = 1 {
        didSet {
            if maxValue < minValue {
                maxValue = minValue
            }
            if currentValue < minValue {
                currentValue = minValue
            }
            updateValues()
            
        }
    }
    
    @IBInspectable private var currentValue: CGFloat = 0.5 {
        didSet {
            updateValues()
            
        }
    }
    
    var fillAmount: CGFloat = 0.5 {
        didSet {
            sendActions(for: .valueChanged)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        layer.addSublayer(trackLayer)
        trackLayer.fillColor = trackColor.cgColor
        
        layer.addSublayer(fillLayer)
        fillLayer.fillColor = accentColor.cgColor
        
        
        
        print("minValue: \(minValue)")
        print("maxValue: \(maxValue)")
        print("currentValue: \(currentValue)")
        print("fillAmount: \(fillAmount)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
        
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.cornerRadius = cornerRadius
        let layerWidth = layer.frame.size.width
        let layerHeight = layer.frame.size.height

        let trackPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: layerWidth, height: layerHeight)).cgPath

        trackLayer.path = trackPath

        let fillPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: layerWidth, height: layerHeight)).cgPath

        fillLayer.path = fillPath
    }

    private func updateValues() {
        fillAmount = currentValue / (maxValue - minValue)
    }
    
    //MARK: Touch tracking methods
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        delegate?.myTrackingBegan()
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var point = touch.location(in: self)
        
        delegate?.myTrackingContinuing(location: point)
        
        if point.x < 0 {
            point.x = 0
        } else if point.x > layer.frame.width {
            point.x = layer.frame.width
        }
        
        let percentX = point.x / layer.frame.width
        fillAmount = percentX
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        delegate?.myTrackingEnded()
    }

    func updateFill(_ bounds: CGRect) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        //fillLayer.transform = CATransform3DMakeScale(fillAmount, 1.0, 1.0)
        
        trackLayer.bounds = bounds
        trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        CATransaction.commit()
    }
    
    private func updateLayerFrames() {
        updateBounds(bounds)
    }
    
    private func updateBounds(_ bounds: CGRect) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.bounds = bounds
        trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        
    }
    
}
