//
//  CoffeeMO+CoreDataProperties.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/25/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//
//

import Foundation
import CoreData


extension CoffeeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoffeeMO> {
        return NSFetchRequest<CoffeeMO>(entityName: "Coffee")
    }

    @NSManaged public var name: String
    @NSManaged public var origin: String
    @NSManaged public var roaster: String
    @NSManaged public var roastLevel: String
    @NSManaged public var id: UUID
    @NSManaged public var note: NSSet?

}

// MARK: Generated accessors for note
extension CoffeeMO {

    @objc(addNoteObject:)
    @NSManaged public func addToNote(_ value: NoteMO)

    @objc(removeNoteObject:)
    @NSManaged public func removeFromNote(_ value: NoteMO)

    @objc(addNote:)
    @NSManaged public func addToNote(_ values: NSSet)

    @objc(removeNote:)
    @NSManaged public func removeFromNote(_ values: NSSet)

}

extension CoffeeMO : Identifiable {

}
