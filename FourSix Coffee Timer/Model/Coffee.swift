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
    enum Process: Int, CaseIterable {
        case unknown, washed, natural, honey
    }

    var roaster: String = ""
    var name: String = ""
    var origin: String = ""
    var roastLevel: String = ""
    var process: Process = .unknown

    init() { }

    init(managedObject: NSManagedObject) {
        // swiftlint:disable:next force_cast
        let coffeeMO = managedObject as! CoffeeMO
        self.roaster = coffeeMO.roaster
        self.name = coffeeMO.name
        self.origin = coffeeMO.origin
        self.roastLevel = coffeeMO.roastLevel
        self.process = Coffee.Process(rawValue: Int(coffeeMO.processRawValue)) ?? .unknown
    }

    init(roaster: String, name: String, origin: String, roastLevel: String, process: Coffee.Process) {
        self.roaster = roaster
        self.name = name
        self.origin = origin
        self.roastLevel = roastLevel
        self.process = process
    }
}

extension Coffee {
    static let testDetails1 = Coffee(roaster: "Coava", name: "Meaza", origin: "Ethiopia", roastLevel: "Light", process: .washed)

    static let testDetails2 = Coffee(roaster: "Stumptown", name: "Hair Bender", origin: "Africa and Latin America", roastLevel: "Medium", process: .unknown)
}
