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
    
    public init(coreDataStack: CoreDataStack) {
        self.mainContext = coreDataStack.mainContext
        self.backgroundContext = coreDataStack.newDerivedContext()
    }
}

extension DataManager {
    func save(_ object: NSManagedObject) {
        guard let context = object.managedObjectContext else { return }
        saveContext(context)
    }
    
    func delete(_ object: NSManagedObject) {
        guard let context = object.managedObjectContext else { return }
        context.perform {
            context.delete(object)
            self.saveContext(context)
        }
    }
    
    func delete(_ objectID: NSManagedObjectID) {
        backgroundContext.perform {
            let object = self.backgroundContext.object(with: objectID)
            self.delete(object)
        }
    }
    
    public func saveContext() {
        saveContext(mainContext)
    }
    
    public func saveContext(_ context: NSManagedObjectContext) {
        if context != mainContext {
            saveDerivedContext(context)
            return
        }
        
        context.perform {
            guard context.hasChanges else { return }
            
            do {
                try context.save()
                print("Core Data main context saved.")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                    print("Core Data derived context saved.")
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        saveContext(mainContext)
    }
    
    // MARK: New Object Methods
    
    @discardableResult func newNoteMO(session: Session, recipe: Recipe, coffee: Coffee) -> NoteMO {
        let newNote = NoteMO(context: mainContext)
        newNote.date = Date()
        
        let newSession = newSessionMO(from: session)
        newNote.session = newSession
        
        let newRecipe = newRecipeMO(from: recipe)
        newNote.recipe = newRecipe
        
        let newCoffee = newCoffeeMO(from: coffee)
        newNote.coffee = newCoffee
        
        saveContext(mainContext)
        
        return newNote
    }
    
    @discardableResult func newSessionMO(from session: Session) -> SessionMO {
        let newSession = SessionMO(context: mainContext)
        newSession.averageDrawdown = session.averageDrawdown()
        newSession.totalTime = session.totalTime
        newSession.drawdownTimes = session.drawdownTimes
        
        return newSession
    }
    
    @discardableResult func newRecipeMO(from recipe: Recipe) -> RecipeMO {
        let newRecipe = RecipeMO(context: mainContext)
        newRecipe.balanceRaw = Double(recipe.balance.rawValue)
        newRecipe.coffee = Double(recipe.coffee)
        newRecipe.interval = recipe.interval
        newRecipe.strengthRaw = Int64(recipe.strength.rawValue)
        newRecipe.waterTotal = Double(recipe.waterTotal)
        newRecipe.waterPours = recipe.waterPours.map { Double($0) }
        
        return newRecipe
    }
    
    @discardableResult func newCoffeeMO(from coffee: Coffee) -> CoffeeMO {
        let newCoffeeMO = CoffeeMO(context: mainContext)
        newCoffeeMO.name = coffee.name
        newCoffeeMO.origin = coffee.origin
        newCoffeeMO.roastLevel = coffee.roastLevel
        newCoffeeMO.roaster = coffee.roaster
        
        return newCoffeeMO
    }
}
