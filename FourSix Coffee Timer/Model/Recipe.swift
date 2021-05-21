//
//  Recipe.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/18/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation
import CoreData

enum Balance: Float, CaseIterable {
    case sweet = 0.42
    case even = 0.5
    case bright = 0.58
}

enum Strength: Int, CaseIterable {
    case light = 2
    case medium = 3
    case strong = 4
}

struct Recipe: ManagedObjectInitializable {
    static let coffeeMin: Float = 5.0
    static let coffeeMax: Float = 40.0
    static let acceptableCoffeeRange: ClosedRange<Float> = 15...25
    static let defaultRecipe = Recipe(coffee: 20,
                                      waterTotal: 300,
                                      waterPours: [60, 60, 60, 60, 60],
                                      interval: 45,
                                      balance: .even,
                                      strength: .medium)

    var coffee: Float
    var waterTotal: Float
    var waterPours: [Float]
    var interval: TimeInterval
    var balance: Balance
    var strength: Strength

    init(managedObject: NSManagedObject) {
        // swiftlint:disable:next force_cast
        let recipeMO = managedObject as! RecipeMO

        let balance = Balance(rawValue: Float(recipeMO.balanceRaw)) ?? .even
        let strength = Strength(rawValue: Int(recipeMO.strengthRaw)) ?? .medium

        self.coffee = Float(recipeMO.coffee)
        self.waterTotal = Float(recipeMO.waterTotal)
        self.waterPours = recipeMO.waterPours.map { Float($0) }
        self.interval = recipeMO.interval
        self.balance = balance
        self.strength = strength
    }

    init(coffee: Float, waterTotal: Float, waterPours: [Float], interval: TimeInterval, balance: Balance, strength: Strength) {
        self.coffee = coffee
        self.waterTotal = waterTotal
        self.waterPours = waterPours
        self.interval = interval
        self.balance = balance
        self.strength = strength
    }
}
