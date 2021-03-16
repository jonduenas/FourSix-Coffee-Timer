//
//  Int.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/3/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

extension Int {
    func convertToMinAndSec() -> (Int, Int) {
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        
        return (minutes, seconds)
    }
}
