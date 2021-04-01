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
    
    func stringFromDate(component: Calendar.Component) -> String {
        let dateFormatter = DateFormatter()
        
        switch component {
        case .month:
            dateFormatter.dateFormat = "MMM"
        case .day:
            dateFormatter.dateFormat = "d"
        case .year:
            dateFormatter.dateFormat = "yyyy"
        default:
            return ""
        }
        
        return dateFormatter.string(from: self)
    }
}
