//
//  Calculator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/18/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

struct Calculator {

    func calculateRecipe(balance: Balance, strength: Strength, coffee: Float, water: Float, stepInterval: TimeInterval) -> Recipe {
        var waterPours = [Float]()

        let water40 = water * 0.4
        let firstPour = water40 * balance.rawValue
        let secondPour = water40 - firstPour

        waterPours.insert(firstPour.rounded(), at: 0)
        waterPours.insert(secondPour.rounded(), at: 1)

        let water60 = water * 0.6
        let water60Count = strength.rawValue
        let water60Pour = water60 / Float(water60Count)

        waterPours.append(contentsOf: repeatElement(water60Pour.rounded(), count: water60Count))

        let recipe = Recipe(
            coffee: coffee,
            waterTotal: water,
            waterPours: waterPours,
            interval: stepInterval,
            balance: balance,
            strength: strength
        )

        return recipe
    }
}
