//
//  DatePickerView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/15/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

protocol DatePickerViewDelegate: AnyObject {
    func datePickerView(_ datePickerView: DatePickerView, didChangeToDate date: Date?)
}

class DatePickerView: RoundedView {
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var roastDateLabel: UILabel!
    
    let datePickerVisibleHeight_iOS14: CGFloat = 350
    let datePickerVisibleHeight_iOS13: CGFloat = 285
    let datePickerHiddenHeight: CGFloat = 50
    let emptyDateColor: UIColor = .secondaryLabel
    let emptyDateText: String = "Select Date"
    let filledDateColor: UIColor = .label
    
    weak var delegate: DatePickerViewDelegate?
    
    private(set) var roastDate: Date? = nil {
        didSet {
            if let date = roastDate {
                roastDateLabel.text = date.stringFromDate(dateStyle: .medium, timeStyle: nil)
                
                if roastDateLabel.textColor == emptyDateColor {
                    roastDateLabel.textColor = filledDateColor
                }
            } else {
                roastDateLabel.text = emptyDateText
                roastDateLabel.textColor = emptyDateColor
            }
        }
    }
    
    private(set) var datePickerIsHidden: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    private func commonInit() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        
        roastDateLabel.text = emptyDateText
        roastDateLabel.textColor = emptyDateColor
    }
    
    func showDatePicker(_ show: Bool) {
        guard datePickerIsHidden == show else { return }
        
        datePickerIsHidden = !show
        
        if #available(iOS 14.0, *) {
            self.datePickerHeight.constant = (show ? self.datePickerVisibleHeight_iOS14 : self.datePickerHiddenHeight)
        } else {
            self.datePickerHeight.constant = (show ? self.datePickerVisibleHeight_iOS13 : self.datePickerHiddenHeight)
        }
    }
    
    func setDate(_ date: Date?) {
        guard roastDate != date else { return }
        roastDate = date
        datePicker.date = date ?? Date()
        delegate?.datePickerView(self, didChangeToDate: date)
    }
    
    @IBAction private func didChangeDate(_ sender: UIDatePicker) {
        setDate(sender.date)
    }
}
