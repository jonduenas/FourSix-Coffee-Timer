//
//  Brace+UIBezierPath.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/23/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

extension UIBezierPath {
    class func brace(from start: CGPoint, to end: CGPoint) -> UIBezierPath {
        let path = self.init()
        path.move(to: .zero)
        path.addCurve(to: CGPoint(x: 0.5, y: -0.1), controlPoint1: CGPoint(x: 0, y: -0.2), controlPoint2: CGPoint(x: 0.5, y: 0.1))
        path.addCurve(to: CGPoint(x: 1, y: 0), controlPoint1: CGPoint(x: 0.5, y: 0.1), controlPoint2: CGPoint(x: 1, y: -0.2))
        
        let scaledCosine = end.x - start.x
        let scaledSine = end.y - start.y
        let transform = CGAffineTransform(a: scaledCosine, b: scaledSine, c: -scaledSine, d: scaledCosine, tx: start.x, ty: start.y)
        path.apply(transform)
        return path
    }
}
