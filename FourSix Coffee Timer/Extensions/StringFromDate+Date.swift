//
//  StringFromDate+Date.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/23/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

extension Date {
    func stringFromDate(dateStyle: DateFormatter.Style?, timeStyle: DateFormatter.Style?) -> String {
        guard dateStyle != nil || timeStyle != nil else {
            print("stringFromDate needs at least one valid date or time style.")
            return ""
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current

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

    func stringGreetingFromDate(using calendar: Calendar = Calendar.current) -> String {
        guard let noon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self) else { return "" }
        guard let fivePM = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: self) else { return "" }

        if self < noon {
            return "Good morning..."
        } else if self < fivePM {
            return "Good afternoon..."
        } else {
            return "Good evening..."
        }
    }
}
