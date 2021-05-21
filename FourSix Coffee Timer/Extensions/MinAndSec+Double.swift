//
//  MinAndSec+Double.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/3/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

extension Double {
    var minAndSecString: String {
        let interval = TimeInterval(self)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated

        return formatter.string(from: interval) ?? String(self)
    }

    var minAndSec: (Double, Double) {
        let minutes = (self / 60).rounded(.down)
        let seconds = self.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60).rounded(.down)

        return (minutes, seconds)
    }
}
