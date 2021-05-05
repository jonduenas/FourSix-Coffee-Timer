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
    func didChangePickerVisibility(_ datePickerView: DatePickerView)
}

class DatePickerView: RoundedView {
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var roastDateLabel: UILabel!
    @IBOutlet weak var labelsContainerView: UIView!
    
    private let emptyDateColor: UIColor = .secondaryLabel
    private let emptyDateText: String = "Select Date"
    private let filledDateColor: UIColor = .label
    
    weak var delegate: DatePickerViewDelegate?
    private var firstInit: Bool = true
    private lazy var datePickerVisibleHeight: CGFloat = {
        let labelsContainerHeight = labelsContainerView.frame.height
        let datePickerHeight = datePicker.frame.height
        return labelsContainerHeight + datePickerHeight + 8
    }()
    
    private(set) var datePickerIsHidden: Bool = false
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if firstInit {
            datePickerHeight.constant = labelsContainerView.frame.height
            firstInit = false
        }
    }
    
    private func commonInit() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        
        roastDateLabel.text = emptyDateText
        roastDateLabel.textColor = emptyDateColor
        
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLabelsView(sender:)))
        labelsContainerView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapLabelsView(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            self.showDatePicker(self.datePickerIsHidden)
            self.delegate?.didChangePickerVisibility(self)
        }
    }
    
    func showDatePicker(_ show: Bool) {
        guard datePickerIsHidden == show else { return }
        
        datePickerIsHidden = !show
        
        datePickerHeight.constant = (show ? datePickerVisibleHeight : labelsContainerView.frame.height)
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
