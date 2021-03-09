//
//  IntervalCell.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/8/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class IntervalCell: TextFieldTableCell {
    private var pickerView: IntervalPickerView?
    private var dataSource = PickerDataSource()
    
    lazy var interval = dataSource.selectedInterval {
        didSet {
            dataSource.selectedInterval = interval
            
            if interval >= 60 {
                let (minutes, seconds) = interval.convertToMinAndSec()
                cellTextField.text = "\(minutes) min \(seconds) sec"
            } else {
                cellTextField.text = "\(interval) sec"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurePicker()
    }
    
    private func configurePicker() {
        pickerView = IntervalPickerView(frame: .zero,
                                     dataSource: dataSource,
                                     delegate: self,
                                     toolbarDelegate: self)
        cellTextField.inputView = pickerView
        cellTextField.inputAccessoryView = pickerView?.toolbar
        
        // Set picker to current saved value
        let (minutes, seconds) = interval.convertToMinAndSec()
        let currentMinIndex = dataSource.intervalMin.firstIndex(of: minutes) ?? 0
        let currentSecIndex = dataSource.intervalSec.firstIndex(of: seconds) ?? 0
        
        pickerView?.selectRow(currentMinIndex, inComponent: IntervalPickerComponent.minValue.rawValue, animated: false)
        pickerView?.selectRow(currentSecIndex, inComponent: IntervalPickerComponent.secValue.rawValue, animated: false)
    }
}

extension IntervalCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let intervalComponent = IntervalPickerComponent(rawValue: component)
        
        switch intervalComponent {
        case .minValue:
            return String(dataSource.intervalMin[row])
        case .secValue:
            return String(dataSource.intervalSec[row])
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let minutes = dataSource.intervalMin[pickerView.selectedRow(inComponent: IntervalPickerComponent.minValue.rawValue)]
        let seconds = dataSource.intervalSec[pickerView.selectedRow(inComponent: IntervalPickerComponent.secValue.rawValue)]
        interval = (minutes * 60) + seconds
    }
}

extension IntervalCell: ToolBarPickerViewDelegate {
    func didTapDone(_ picker: UIPickerView) {
        if interval == 0 {
            interval += 1
            picker.selectRow(1, inComponent: IntervalPickerComponent.secValue.rawValue, animated: true)
        }
        cellTextField.resignFirstResponder()
    }
    
    func didTapDefault(_ picker: UIPickerView) {
        let defaultInterval = Int(Recipe.defaultRecipe.interval)
        guard defaultInterval != dataSource.selectedInterval else { return }
        guard let defaultIntervalIndex = dataSource.intervalSec.firstIndex(of: defaultInterval) else { return }
        
        picker.selectRow(0, inComponent: IntervalPickerComponent.minValue.rawValue, animated: true)
        picker.selectRow(defaultIntervalIndex, inComponent: IntervalPickerComponent.secValue.rawValue, animated: true)
        cellTextField.text = "\(defaultInterval) sec"
        interval = defaultInterval
    }
}
