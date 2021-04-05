//
//  DateTextField.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/5/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class DateTextField: UITextField {
    var datePicker: UIDatePicker!
    var dateValue: Date = Date()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeDatePicker()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeDatePicker()
    }

    private func initializeDatePicker() {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = .current
        datePicker.sizeToFit()
        
        datePicker.addTarget(self, action: #selector(didChangeDateValue(sender:)), for: .valueChanged)
        
        inputView = datePicker
        datePicker.backgroundColor = UIColor(named: AssetsColor.secondaryBackground.rawValue)
        
        self.datePicker = datePicker
    }
    
    @objc private func didChangeDateValue(sender: UIDatePicker) {
        print("Set date to date: \(sender.date)")
        text = sender.date.stringFromDate(dateStyle: .medium, timeStyle: nil)
        dateValue = datePicker.date
    }
}
