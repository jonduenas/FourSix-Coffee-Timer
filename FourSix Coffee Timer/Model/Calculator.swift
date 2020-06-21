//
//  Calculator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/18/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

struct Calculator {
    
    var recipe: Recipe?
    var waterPours = [Double]()
    
    mutating func calculate4(_ balance: Balance, with coffee: Double, _ water: Double) {
        let water40 = water * 0.4
        let firstPour = water40 * balance.rawValue
        let secondPour = water40 - firstPour

        waterPours.insert(firstPour.rounded(), at: 0)
        waterPours.insert(secondPour.rounded(), at: 1)
    }
    
    mutating func calculate6(_ strength: Strength, with coffee: Double,_ water: Double) {
        let water60 = water * 0.6
        let water60Count = strength.rawValue
        let water60Pour = water60 / Double(water60Count)
        
        waterPours.append(contentsOf: repeatElement(water60Pour.rounded(), count: water60Count))
        
        recipe = Recipe(waterTotal: water, coffee: coffee, waterPours: waterPours)
    }
    
    func getPours() -> [Double] {
        return recipe?.waterPours ?? [60, 60, 60, 60, 60]
    }
    
    func getTotalWater() -> Double {
        return recipe?.waterTotal ?? 300
    }
    
    func getRecipe() -> Recipe {
        return recipe ?? Recipe(waterTotal: 300, coffee: 20, waterPours: [60, 60, 60, 60, 60])
    }
    
}
