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
            print(recipe.waterPours)
        case .neutral:
            setBalance(balance)
            print(recipe.waterPours)
        case .bright:
            setBalance(balance)
            print(recipe.waterPours)
        }
    }
    
    func calculate6() {
        
    }
    
    mutating func setBalance(_ balance: Balance) {
        let water40 = recipe.waterTotal * 0.4
        let firstPour = water40 * balance.rawValue
        let secondPour = water40 - firstPour
        recipe.waterPours.removeAll()
        recipe.waterPours.append(firstPour.rounded())
        recipe.waterPours.append(secondPour.rounded())
    }
    
}
