//
//  DatePicker.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/23/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

extension UITextField {
    func datePicker<T>(target: T, selectedDate: Date? = nil, datePickerMode: UIDatePicker.Mode = .date, valueChangedSelector: Selector) {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = .wheels
        
        if let date = selectedDate {
            datePicker.date = date
        }
        
        datePicker.addTarget(target, action: valueChangedSelector, for: .valueChanged)
        
        inputView = datePicker
        datePicker.backgroundColor = UIColor(named: AssetsColor.secondaryBackground.rawValue)
    }
}
