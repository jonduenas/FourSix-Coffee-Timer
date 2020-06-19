//
//  RecipeCalculator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/18/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

struct Calculator {
    
    var recipe = Recipe()
//    let balance: Balance
    //    let strength: Strength
    
    mutating func calculate4(with balance: Balance) {
        switch balance {
        case .sweet:
            setBalance(balance)
        case .neutral:
            setBalance(balance)
        case .bright:
            setBalance(balance)
        }
    }
    
    mutating func calculate6(with strength: Strength) {
        switch strength {
        case .light:
            setStrength(strength)
        case .medium:
            setStrength(strength)
        case .strong:
            setStrength(strength)
        }
    }
    
    mutating func setBalance(_ balance: Balance) {
        let water40 = recipe.waterTotal * 0.4
        let firstPour = water40 * balance.rawValue
        let secondPour = water40 - firstPour
        recipe.waterPours.removeAll()
        recipe.waterPours.append(firstPour.rounded())
        recipe.waterPours.append(secondPour.rounded())
    }
    
    mutating func setStrength(_ strength: Strength) {
        let water60 = recipe.waterTotal * 0.6
        let water60Count = strength.rawValue
        let water60Pour = water60 / Double(water60Count)
        recipe.waterPours.append(contentsOf: repeatElement(water60Pour.rounded(), count: water60Count))
    }
}
