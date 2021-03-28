//
//  Coffee.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/28/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation
import CoreData

struct Coffee: ManagedObjectInitializable {
    var roaster: String
    var name: String
    var origin: String
    var roastLevel: String
    
    init(managedObject: NSManagedObject) {
        let coffeeMO = managedObject as! CoffeeMO
        self.roaster = coffeeMO.roaster
        self.name = coffeeMO.name
        self.origin = coffeeMO.origin
        self.roastLevel = coffeeMO.roastLevel
    }
    
    init(roaster: String, name: String, origin: String, roastLevel: String) {
        self.roaster = roaster
        self.name = name
        self.origin = origin
        self.roastLevel = roastLevel
    }
}

extension Coffee {
    static let testDetails1 = Coffee(roaster: "Coava", name: "Meaza", origin: "Ethiopia", roastLevel: "Light")

    static let testDetails2 = Coffee(roaster: "Stumptown", name: "Hair Bender", origin: "Africa and Latin America", roastLevel: "Medium")
}
