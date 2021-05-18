//
//  CoffeeDataSource.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/8/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import CoreData

class CoffeeDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentSnapshot = snapshot()
        return currentSnapshot.sectionIdentifiers[section]
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
