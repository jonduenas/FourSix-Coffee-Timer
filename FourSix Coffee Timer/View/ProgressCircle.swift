//
//  ProgressCircle.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class ProgressCircle: UIView {
    
    private var progressLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!
    
    var progressAmount: Double = 0
    
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
    
    //MARK: Draw Circle Methods
    
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
        trackLayer = createCircleShapeLayer(strokeColor: .systemGray2, fillColor: .clear, strokeEnd: 1)
        
        self.layer.addSublayer(trackLayer)
        
        //create progress layer
        progressLayer = createCircleShapeLayer(strokeColor: UIColor(named: "Accent")!, fillColor: .clear, strokeEnd: 0)
        
        self.layer.addSublayer(progressLayer)
    }
    
    private func layoutProgressBar() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: (self.frame.size.height / 2) - 10, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
        
        let center = self.convert(self.center, from: self.superview)
        
        progressLayer.position = center
        trackLayer.position = center
    }
    
    //MARK: Animation Methods
    
    func animateProgress(from start: Double, to end: Double) {
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            
            basicAnimation.fromValue = start
            basicAnimation.toValue = end
        basicAnimation.duration = 1
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
            
            progressLayer.add(basicAnimation, forKey: "circleAnimation")
    }
    
//    func startProgressBar(duration: Double) {
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        
//        basicAnimation.fromValue = 0
//        basicAnimation.toValue = 1
//        basicAnimation.duration = duration
//        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
//        basicAnimation.isRemovedOnCompletion = false
//        
//        progressLayer.add(basicAnimation, forKey: "circleAnimation")
//    }
//    
    func pauseAnimation() {
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 1
        progressLayer.timeOffset = 0
        progressLayer.beginTime = 0
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
    }
    
    func resetProgress() {
        progressLayer.removeAllAnimations()
        progressLayer.strokeEnd = 0
    }
}

// MARK: Extensions

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
