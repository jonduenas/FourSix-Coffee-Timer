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
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    public init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }
}

extension DataManager {
    func save(_ object: NSManagedObject) {
        guard let context = object.managedObjectContext else { return }
        saveContext(context)
    }
    
    public func saveContext() {
        saveContext(mainContext)
    }
    
    public func saveContext(_ context: NSManagedObjectContext) {
        if context != mainContext {
            saveDerivedContext(context)
            return
        }
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            print("Core Data main context saved.")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            print("Core Data derived context saved.")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        self.saveContext(self.mainContext)
    }
}
