//
//  Recipe.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/18/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

struct Recipe {
    let waterTotal: Float
    let coffee: Float
    let waterPours: [Float]
    let interval: TimeInterval = 45
    let balance: Balance
    let strength: Strength
}
