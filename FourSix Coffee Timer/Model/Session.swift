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
    let totalTime: TimeInterval
    let drawdownTimes: [TimeInterval]
    
    init(managedObject: NSManagedObject) {
        let sessionMO = managedObject as! SessionMO
        self.totalTime = sessionMO.totalTime
        self.drawdownTimes = sessionMO.drawdownTimes
    }
    
    init(drawdownTimes: [TimeInterval], totalTime: TimeInterval) {
        self.drawdownTimes = drawdownTimes
        self.totalTime = totalTime
    }
    
    private func calculateAverage(_ drawdownTimes: [TimeInterval]) -> TimeInterval {
        let averageTime = drawdownTimes.reduce(0, +) / Double(drawdownTimes.count)
        let roundedAverageTime = averageTime.rounded()
        
        return roundedAverageTime
    }
    
    func averageDrawdown() -> TimeInterval {
        return calculateAverage(drawdownTimes)
    }
}
