//
//  Recipe.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/18/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

struct Recipe {
    let waterTotal: Double
    let coffee: Double
    let waterPours: [Double]
    let interval: TimeInterval = 45
    let balance: Balance
    let strength: Strength
}
