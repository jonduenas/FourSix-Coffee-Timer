//
//  RatioCell.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/8/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class RatioCell: TextFieldTableCell {
    private var pickerView: RatioPickerView?
    private var dataSource = PickerDataSource()
    
    lazy var ratio = dataSource.selectedRatio {
        didSet {
            dataSource.selectedRatio = ratio
            cellTextField.text = "1:" + ratio.clean
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurePicker()
    }
    
    private func configurePicker() {
        pickerView = RatioPickerView(frame: .zero,
                                     dataSource: dataSource,
                                     delegate: self,
                                     toolbarDelegate: self)
        cellTextField.inputView = pickerView
        cellTextField.inputAccessoryView = pickerView?.toolbar
        
        // Set picker to current saved value
        let currentRatioIndex = dataSource.ratioValueArray.firstIndex(of: Int(ratio)) ?? 14
        pickerView?.selectRow(currentRatioIndex, inComponent: RatioPickerComponent.consequent.rawValue, animated: false)
        
        let currentRatioDecimal = ratio.truncatingRemainder(dividingBy: 1) * 10
        let decimalIndex = dataSource.ratioDecimalValueArray.firstIndex(of: Int(currentRatioDecimal)) ?? 0
        pickerView?.selectRow(decimalIndex, inComponent: RatioPickerComponent.decimalValue.rawValue, animated: false)
    }
}

extension RatioCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let ratioComponent = RatioPickerComponent(rawValue: component)
        
        switch ratioComponent {
        case .consequent:
            return String(dataSource.ratioValueArray[row])
        case .decimalValue:
            return String(dataSource.ratioDecimalValueArray[row])
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newRatioInt = dataSource.ratioValueArray[pickerView.selectedRow(inComponent: RatioPickerComponent.consequent.rawValue)]
        let newRatioDecimal = dataSource.ratioDecimalValueArray[
            pickerView.selectedRow(inComponent: RatioPickerComponent.decimalValue.rawValue)
        ]
        let newRatio: Float = Float(newRatioInt) + (Float(newRatioDecimal) * 0.1)
        ratio = newRatio
    }
}

extension RatioCell: ToolBarPickerViewDelegate {
    func didTapDone(_ picker: UIPickerView) {
        cellTextField.resignFirstResponder()
    }
    
    func didTapDefault(_ picker: UIPickerView) {
        let defaultRatio = Ratio.defaultRatio.consequent
        guard defaultRatio != ratio else { return }
        
        guard let defaultRatioIndex = dataSource.ratioValueArray.firstIndex(of: Int(defaultRatio)) else { return }
        picker.selectRow(defaultRatioIndex, inComponent: RatioPickerComponent.consequent.rawValue, animated: true)
        picker.selectRow(0, inComponent: RatioPickerComponent.decimalValue.rawValue, animated: true)
        
        ratio = defaultRatio
    }
}
