//
//  Double+clean.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/8/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

//Converts Double to String with decimal place if it has one or more and no decimal place if there are none
extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
