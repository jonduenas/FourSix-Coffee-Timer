//
//  Recipe.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/18/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

enum Balance: Float {
    case sweet = 0.42
    case neutral = 0.5
    case bright = 0.58
}

enum Strength: Int {
    case light = 2
    case medium = 3
    case strong = 4
}

struct Recipe {
    let coffee: Float
    let waterTotal: Float
    let waterPours: [Float]
    let interval: TimeInterval
    let balance: Balance
    let strength: Strength
}
