//
//  PickerDataSource.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/3/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

enum RatioPickerComponent: Int, CaseIterable {
    case emptySpaceLeft
    case antecedent
    case colon
    case consequent
    case decimal
    case decimalValue
    case emptySpaceRight
}

enum IntervalPickerComponent: Int, CaseIterable {
    case emptySpaceLeft
    case minValue
    case secValue
    case emptySpaceRight
}

enum SettingsPicker: Int {
    case ratio, interval
}

class PickerDataSource: NSObject, UIPickerViewDataSource {
    let ratioValueArray = Array(1...50)
    let ratioDecimalValueArray = Array(0...9)
    let intervalSec = Array(0...59)
    let intervalMin = Array(0...9)
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == SettingsPicker.ratio.rawValue {
            return RatioPickerComponent.allCases.count
        } else {
            return IntervalPickerComponent.allCases.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == SettingsPicker.ratio.rawValue {
            let ratioComponent = RatioPickerComponent(rawValue: component)
            
            switch ratioComponent {
            case .consequent:
                return ratioValueArray.count
            case .decimalValue:
                return ratioDecimalValueArray.count
            default:
                return 0
            }
        } else {
            let intervalComponent = IntervalPickerComponent(rawValue: component)
            
            switch intervalComponent {
            case .minValue:
                return intervalMin.count
            case .secValue:
                return intervalSec.count
            default:
                return 0
            }
        }
    }
}
