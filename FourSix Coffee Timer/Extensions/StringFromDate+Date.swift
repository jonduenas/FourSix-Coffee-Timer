//
//  StringFromDate+Date.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/23/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

extension Date {
    func stringFromDate(dateStyle: DateFormatter.Style? = .medium, timeStyle: DateFormatter.Style? = nil) -> String {
        let dateFormatter = DateFormatter()
        
        if let dateStyle = dateStyle {
            dateFormatter.dateStyle = dateStyle
        }
        
        if let timeStyle = timeStyle {
            dateFormatter.timeStyle = timeStyle
        }
        
        return dateFormatter.string(from: self)
    }
}
