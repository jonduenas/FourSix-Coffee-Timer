//
//  MangedObjectInitializable.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/28/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObjectInitializable {
    init(managedObject: NSManagedObject)
}
