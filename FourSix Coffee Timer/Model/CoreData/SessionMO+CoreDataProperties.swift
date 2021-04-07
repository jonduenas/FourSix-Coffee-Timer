//
//  SessionMO+CoreDataProperties.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/6/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//
//

import Foundation
import CoreData


extension SessionMO {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<SessionMO> {
        return NSFetchRequest<SessionMO>(entityName: "Session")
    }

    @NSManaged public var averageDrawdown: Double
    @NSManaged public var totalTime: Double
    @NSManaged public var drawdownTimes: [TimeInterval]
    @NSManaged public var note: NoteMO?

}

extension SessionMO : Identifiable {

}
