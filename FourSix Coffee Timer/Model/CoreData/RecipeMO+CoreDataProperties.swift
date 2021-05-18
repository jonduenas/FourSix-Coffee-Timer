//
//  RecipeMO+CoreDataProperties.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/29/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//
//

import Foundation
import CoreData

extension RecipeMO {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<RecipeMO> {
        return NSFetchRequest<RecipeMO>(entityName: "Recipe")
    }

    @NSManaged public var balanceRaw: Double
    @NSManaged public var coffee: Double
    @NSManaged public var interval: Double
    @NSManaged public var strengthRaw: Int64
    @NSManaged public var waterTotal: Double
    @NSManaged public var waterPours: [Double]
    @NSManaged public var note: NoteMO?

}

extension RecipeMO: Identifiable {

}
