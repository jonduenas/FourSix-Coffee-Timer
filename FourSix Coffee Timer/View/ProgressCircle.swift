//
//  ProgressCircle.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class ProgressCircle: UIControl, CAAnimationDelegate {
    
    let progressStrokeColor = UIColor(named: "Fill") ?? #colorLiteral(red: 0.4103244543, green: 0.5630832911, blue: 0.9429332614, alpha: 1)
    let progressWarningStrokeColor = UIColor.red
    private let trackStrokeColor = UIColor.systemGray4
    
    var progressLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!
    
    private(set) var isAnimating: Bool = false
    private(set) var progressAmount: CGFloat = 0 {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createProgressBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createProgressBar()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutProgressBar()
    }
    
    // MARK: Draw Circle Methods
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor, strokeEnd: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()

        layer.fillColor = fillColor.cgColor
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.strokeEnd = strokeEnd
        layer.lineCap = CAShapeLayerLineCap.round
        
        return layer
    }
    
    private func createProgressBar() {
        //create track layer
        trackLayer = createCircleShapeLayer(strokeColor: trackStrokeColor, fillColor: .clear, strokeEnd: 1)
        
        self.layer.addSublayer(trackLayer)
        
        //create progress layer
        progressLayer = createCircleShapeLayer(strokeColor: progressStrokeColor, fillColor: .clear, strokeEnd: 0)
        
        self.layer.addSublayer(progressLayer)
    }
    
    private func layoutProgressBar() {
        let radius = (self.frame.size.height / 2) - 10
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
        
        let center = self.convert(self.center, from: self.superview)
        
        progressLayer.position = center
        trackLayer.position = center
    }
    
    // MARK: Animation Methods
    
    func animateProgress(from start: CGFloat, to end: CGFloat, duration: TimeInterval, completion: (() -> Void)? = nil) {
        
        isAnimating = true
        let fromProgress = (0...1).clamp(value: start)
        let toProgress = (0...1).clamp(value: end)
        
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink.add(to: .main, forMode: RunLoop.Mode.common)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let basicAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        basicAnimation.delegate = self
        basicAnimation.fromValue = fromProgress
        basicAnimation.toValue = toProgress
        basicAnimation.duration = duration
        basicAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            self.progressAmount = toProgress
            displayLink.invalidate()
            self.isAnimating = false
            completion?()
        }
        
        progressLayer.strokeEnd = toProgress
        progressLayer.add(basicAnimation, forKey: "animateProgress_\(arc4random())")
        CATransaction.commit()
    }
    
    @objc private func animationDidUpdate(displayLink: CADisplayLink) {
        guard var progress = progressLayer.presentation()?.strokeEnd else { return }
        progress = (0...1).clamp(value: progress)
    }
    
    func setStrokeColor(for layer: CAShapeLayer, to color: UIColor, animated: Bool) {
        if animated {
            CATransaction.begin()
            let colorChangeAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeColor))
            colorChangeAnimation.delegate = self
            colorChangeAnimation.fromValue = layer.strokeColor
            colorChangeAnimation.toValue = color.cgColor
            colorChangeAnimation.duration = 0.25
            colorChangeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
            
            layer.strokeColor = color.cgColor
            layer.add(colorChangeAnimation, forKey: "animateStrokeColor_\(arc4random())")
            CATransaction.commit()
        } else {
            layer.strokeColor = color.cgColor
        }
    }
    
    // MARK: Update colors on dark mode toggle
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateColors()
        self.setNeedsDisplay()
    }
    
    private func updateColors() {
        self.progressLayer.strokeColor = progressStrokeColor.cgColor
        self.trackLayer.strokeColor = trackStrokeColor.cgColor
    }
    
}

// MARK: Extensions

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

extension ClosedRange {
    func clamp(value: Bound) -> Bound {
        return lowerBound > value ? lowerBound : (upperBound < value ? upperBound : value)
    }
}
