//
//  CoreDataStack.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/25/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation
import CoreData

open class CoreDataStack {
    public static let modelName = "FourSix"
    
    public static let managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: CoreDataStack.self)
        return NSManagedObjectModel.mergedModel(from: [bundle])!
    }()
    
    public init() {}
    
    public lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.managedObjectModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container.viewContext.automaticallyMergesChangesFromParent = true
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public func newDerivedContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}
