//
//  RecipeMO+CoreDataProperties.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/25/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//
//

import Foundation
import CoreData


extension RecipeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeMO> {
        return NSFetchRequest<RecipeMO>(entityName: "Recipe")
    }

    @NSManaged public var coffee: Double
    @NSManaged public var interval: Double
    @NSManaged public var balanceRaw: Double
    @NSManaged public var strengthRaw: Int64
    @NSManaged public var waterTotal: WaterMO
    @NSManaged public var waterPours: NSOrderedSet?

}

// MARK: Generated accessors for waterPours
extension RecipeMO {

    @objc(insertObject:inWaterPoursAtIndex:)
    @NSManaged public func insertIntoWaterPours(_ value: WaterMO, at idx: Int)

    @objc(removeObjectFromWaterPoursAtIndex:)
    @NSManaged public func removeFromWaterPours(at idx: Int)

    @objc(insertWaterPours:atIndexes:)
    @NSManaged public func insertIntoWaterPours(_ values: [WaterMO], at indexes: NSIndexSet)

    @objc(removeWaterPoursAtIndexes:)
    @NSManaged public func removeFromWaterPours(at indexes: NSIndexSet)

    @objc(replaceObjectInWaterPoursAtIndex:withObject:)
    @NSManaged public func replaceWaterPours(at idx: Int, with value: WaterMO)

    @objc(replaceWaterPoursAtIndexes:withWaterPours:)
    @NSManaged public func replaceWaterPours(at indexes: NSIndexSet, with values: [WaterMO])

    @objc(addWaterPoursObject:)
    @NSManaged public func addToWaterPours(_ value: WaterMO)

    @objc(removeWaterPoursObject:)
    @NSManaged public func removeFromWaterPours(_ value: WaterMO)

    @objc(addWaterPours:)
    @NSManaged public func addToWaterPours(_ values: NSOrderedSet)

    @objc(removeWaterPours:)
    @NSManaged public func removeFromWaterPours(_ values: NSOrderedSet)

}

extension RecipeMO : Identifiable {

}
