//
//  Recipe.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/18/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

enum Balance: Float, CaseIterable {
    case sweet = 0.42
    case neutral = 0.5
    case bright = 0.58
}

enum Strength: Int, CaseIterable {
    case light = 2
    case medium = 3
    case strong = 4
}

struct Recipe {
    static let coffeeMin: Float = 10.0
    static let coffeeMax: Float = 40.0
    static let acceptableCoffeeRange: ClosedRange<Float> = 15...25
    static let defaultRecipe = Recipe(coffee: 20,
                                      waterTotal: 300,
                                      waterPours: [60, 60, 60, 60, 60],
                                      interval: 45,
                                      balance: .neutral,
                                      strength: .medium)
    
    var coffee: Float
    var waterTotal: Float
    var waterPours: [Float]
    var interval: TimeInterval
    var balance: Balance
    var strength: Strength
}
