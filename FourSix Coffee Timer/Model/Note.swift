//
//  Note.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/18/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

struct Note: Hashable {
    let id: Int
    let recipe: Recipe
    let averageDrawdown: TimeInterval
    let totalTime: TimeInterval
    let date: String
    var rating: Int
    var noteText: String
    var coffeeDetails: CoffeeDetails
    var grindSetting: String
    var waterTemp: Double
}

struct CoffeeDetails: Hashable {
    var roaster: String
    var coffeeName: String
    var origin: String
    var roastDate: Date
    var roastLevel: String
}

extension Note {
    static let testNote1 = Note(id: 1,
                                recipe: Recipe.defaultRecipe,
                                averageDrawdown: 45,
                                totalTime: 240,
                                date: "3/15/2021 - 1:15 PM",
                                rating: 5,
                                noteText: "This cup was perfect.",
                                coffeeDetails: CoffeeDetails.testDetails,
                                grindSetting: "12",
                                waterTemp: 100)
    static let testNote2 = Note(id: 2,
                                recipe: Recipe.defaultRecipe,
                                averageDrawdown: 42,
                                totalTime: 246,
                                date: "3/16/2021 - 11:10 AM",
                                rating: 3,
                                noteText: "Grind finer.",
                                coffeeDetails: CoffeeDetails.testDetails,
                                grindSetting: "18",
                                waterTemp: 95)
}

extension CoffeeDetails {
    static let testDetails = CoffeeDetails(roaster: "Coava", coffeeName: "Meaza", origin: "Ethiopia", roastDate: Date(timeIntervalSince1970: 827382), roastLevel: "Light")
}
