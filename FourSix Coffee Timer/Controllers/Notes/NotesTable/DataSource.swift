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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
