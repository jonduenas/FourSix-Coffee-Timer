//
//  Note.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/18/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

struct Note: Hashable {
    let recipe: Recipe
    let session: Session
    let date: String
    var rating: Int
    var noteText: String
    var coffeeDetails: CoffeeDetails
    var grindSetting: String
    var waterTemp: Double
}

struct Session: Hashable {
    let averageDrawdown: TimeInterval
    let totalTime: TimeInterval
}

struct CoffeeDetails: Hashable {
    var roaster: String
    var coffeeName: String
    var origin: String
    var roastDate: Date
    var roastLevel: String
}

extension Note {
    static let testNote1 = Note(recipe: Recipe(coffee: 25, waterTotal: 350, waterPours: [50, 80, 120, 120], interval: 40, balance: .bright, strength: .strong),
                                session: Session(averageDrawdown: 45, totalTime: 240),
                                date: "3/15/2021 - 1:15 PM",
                                rating: 5,
                                noteText: "This cup was perfect.",
                                coffeeDetails: CoffeeDetails.testDetails,
                                grindSetting: "12",
                                waterTemp: 100)
    static let testNote2 = Note(recipe: Recipe.defaultRecipe,
                                session: Session(averageDrawdown: 47, totalTime: 485),
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
