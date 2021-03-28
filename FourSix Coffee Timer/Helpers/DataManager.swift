//
//  DataManager.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/28/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation
import CoreData

public final class DataManager {
    private let coreDataStack: CoreDataStack
    let managedObjectContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        self.backgroundContext = coreDataStack.newDerivedContext()
    }
}

extension DataManager {
    func save(_ object: NSManagedObject) {
        guard let context = object.managedObjectContext else { return }
        coreDataStack.saveContext(context)
    }
}
