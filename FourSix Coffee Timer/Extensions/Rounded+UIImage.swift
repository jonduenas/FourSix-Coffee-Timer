//
//  Rounded+UIImage.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/27/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

extension UIImage {
    public func rounded(radius: CGFloat) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
