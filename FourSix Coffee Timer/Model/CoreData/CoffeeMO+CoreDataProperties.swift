//
//  CoffeeMO+CoreDataProperties.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/29/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//
//

import Foundation
import CoreData


extension CoffeeMO {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CoffeeMO> {
        return NSFetchRequest<CoffeeMO>(entityName: "Coffee")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var origin: String
    @NSManaged public var roaster: String
    @NSManaged public var roastLevel: String
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension CoffeeMO {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: NoteMO)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: NoteMO)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

extension CoffeeMO : Identifiable {

}
