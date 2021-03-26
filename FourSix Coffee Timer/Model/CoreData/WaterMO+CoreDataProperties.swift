//
//  WaterMO+CoreDataProperties.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/25/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//
//

import Foundation
import CoreData


extension WaterMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WaterMO> {
        return NSFetchRequest<WaterMO>(entityName: "Water")
    }

    @NSManaged public var amount: Double
    @NSManaged public var recipeTotal: RecipeMO?
    @NSManaged public var recipePours: RecipeMO?

}

extension WaterMO : Identifiable {

}
