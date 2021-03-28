//
//  Session.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/28/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation
import CoreData

struct Session: ManagedObjectInitializable {
    let averageDrawdown: TimeInterval
    let totalTime: TimeInterval
    
    init(managedObject: NSManagedObject) {
        let sessionMO = managedObject as! SessionMO
        self.averageDrawdown = sessionMO.averageDrawdown
        self.totalTime = sessionMO.totalTime
    }
    
    init(averageDrawdown: TimeInterval, totalTime: TimeInterval) {
        self.averageDrawdown = averageDrawdown
        self.totalTime = totalTime
    }
}
