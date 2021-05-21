//
//  NoteMO+CoreDataProperties.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/26/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//
//

import Foundation
import CoreData

extension NoteMO {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<NoteMO> {
        return NSFetchRequest<NoteMO>(entityName: "Note")
    }

    @NSManaged public var date: Date
    @NSManaged public var grindSetting: String
    @NSManaged public var rating: Int64
    @NSManaged public var roastDate: Date?
    @NSManaged public var text: String
    @NSManaged public var waterTempC: Double
    @NSManaged public var tempUnitRawValue: Int64
    @NSManaged public var coffee: CoffeeMO?
    @NSManaged public var recipe: RecipeMO
    @NSManaged public var session: SessionMO

}

extension NoteMO: Identifiable {

}
