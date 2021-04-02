//
//  DataSource.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/2/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import CoreData

class DataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID> {
    
    var dataManager: DataManager?
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting cell")
            guard let dataManager = dataManager else { fatalError("DataManager is required for the DataSource class to work.") }

            if let objectID = itemIdentifier(for: indexPath) {
                var snapshot = self.snapshot()
                snapshot.deleteItems([objectID])
                apply(snapshot) {
                    dataManager.backgroundContext.perform {
                        guard let object = try? dataManager.backgroundContext.existingObject(with: objectID) as? NoteMO else { fatalError("Object should exist.") }
                        dataManager.backgroundContext.delete(object)
                        dataManager.saveContext(dataManager.backgroundContext)
                    }
                }
            }
        }
    }
}
