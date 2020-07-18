//
//  Calculator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/18/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

struct Calculator {
    
    var recipe: Recipe?
    var waterPours = [Float]()
    
    mutating func calculate(_ balance: Balance, _ strength: Strength, with coffee: Float, _ water: Float) {
        let water40 = water * 0.4
        let firstPour = water40 * balance.rawValue
        let secondPour = water40 - firstPour

        waterPours.insert(firstPour.rounded(), at: 0)
        waterPours.insert(secondPour.rounded(), at: 1)
    
        let water60 = water * 0.6
        let water60Count = strength.rawValue
        let water60Pour = water60 / Float(water60Count)
        
        waterPours.append(contentsOf: repeatElement(water60Pour.rounded(), count: water60Count))
        
        recipe = Recipe(coffee: coffee, waterTotal: water, waterPours: waterPours, balance: balance, strength: strength)
    }
    
    func getPours() -> [Float] {
        return recipe?.waterPours ?? [60, 60, 60, 60, 60]
    }
    
    func getTotalWater() -> Float {
        return recipe?.waterTotal ?? 300
    }
    
    func getRecipe() -> Recipe {
        return recipe ?? Recipe(coffee: 20, waterTotal: 300, waterPours: [60, 60, 60, 60, 60], balance: .neutral, strength: .medium)
    }
    
}
