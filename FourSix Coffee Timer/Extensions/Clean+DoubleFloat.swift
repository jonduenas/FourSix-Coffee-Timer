//
//  Clean.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/8/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

// Converts Double to String with decimal place if it has one or more and no decimal place if there are none
extension Double {
    var clean: String {
        guard let formattedString = Formatter.decimal.string(for: self) else { return String(self) }

        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : formattedString
    }
}

extension Float {
    var clean: String {
        guard let formattedString = Formatter.decimal.string(for: self) else { return String(self) }

        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : formattedString
    }
}

extension Formatter {
    static let decimal: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = .current
        return numberFormatter
    }()
}
