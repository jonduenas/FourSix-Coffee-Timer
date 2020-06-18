//
//  Recipe.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/18/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

struct Recipe {
    
    let waterTotal: Double
    let coffee: Double
    var waterPours: [Double]
    
    init() {
        self.waterTotal = 300
        self.coffee = 20
        self.waterPours = [60, 60, 60, 60, 60]
    }
    
//    var water40: Double?
//    var water60: Double?
//    var waterPour1: Double = 0
//    var waterPour2: Double = 0
//    var water60Pour: Double = 0
//    var water60Count: Int = 0
    
    
}
