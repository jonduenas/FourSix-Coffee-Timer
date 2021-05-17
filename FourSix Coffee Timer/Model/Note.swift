//
//  Note.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/18/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation
import CoreData

struct Note: ManagedObjectInitializable {
    let recipe: Recipe
    let session: Session
    let date: Date
    var rating: Int
    var noteText: String
    var coffee: Coffee?
    var grindSetting: String
    var waterTempC: Double
    var waterTempUnit: TempUnit
    var roastDate: Date?
    
    init(managedObject: NSManagedObject) {
        // swiftlint:disable:next force_cast
        let noteMO = managedObject as! NoteMO
        
        self.recipe = Recipe(managedObject: noteMO.recipe)
        self.session = Session(managedObject: noteMO.session)
        
        if let coffee = noteMO.coffee {
            self.coffee = Coffee(managedObject: coffee)
        }

        self.date = noteMO.date
        self.rating = Int(noteMO.rating)
        self.noteText = noteMO.text
        self.waterTempC = noteMO.waterTempC
        self.waterTempUnit = TempUnit(rawValue: Int(noteMO.tempUnitRawValue)) ?? .celsius
        self.grindSetting = noteMO.grindSetting
        self.roastDate = noteMO.roastDate
    }
    
    init(recipe: Recipe, session: Session, date: Date, rating: Int, noteText: String, coffee: Coffee, grindSetting: String, waterTempC: Double, waterTempUnit: TempUnit, roastDate: Date? = nil) {
        self.recipe = recipe
        self.session = session
        self.date = date
        self.rating = rating
        self.noteText = noteText
        self.coffee = coffee
        self.grindSetting = grindSetting
        self.waterTempC = waterTempC
        self.waterTempUnit = waterTempUnit
        self.roastDate = roastDate
    }
}

//extension Note {
//    static let testNote1 = Note(recipe: Recipe(coffee: 25, waterTotal: 350, waterPours: [50, 80, 120, 120], interval: 40, balance: .bright, strength: .strong),
//                                session: Session(drawdownTimes: 45, totalTime: 240),
//                                date: Date().addingTimeInterval(-108000),
//                                rating: 5,
//                                noteText: "This cup was perfect.",
//                                coffee: Coffee.testDetails1,
//                                grindSetting: "12",
//                                waterTempC: 100.0,
//                                waterTempUnit: .celsius)
//    static let testNote2 = Note(recipe: Recipe.defaultRecipe,
//                                session: Session(averageDrawdown: 47, totalTime: 485),
//                                date: Date().addingTimeInterval(-250568),
//                                rating: 3,
//                                noteText: "Grind finer.",
//                                coffee: Coffee.testDetails2,
//                                grindSetting: "18",
//                                waterTempC: 95.0,
//                                waterTempUnit: .fahrenheit)
//}
