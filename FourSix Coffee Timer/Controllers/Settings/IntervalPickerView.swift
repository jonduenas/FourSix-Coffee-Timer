//
//  IntervalPickerView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/4/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class IntervalPickerView: UIPickerView {
    var pickerDataSource: PickerDataSource?
    var minuteLabel: UILabel!
    var secondLabel: UILabel!
    
    init(frame: CGRect, dataSource: UIPickerViewDataSource, delegate: UIPickerViewDelegate) {
        super.init(frame: frame)
        self.dataSource = dataSource
        self.delegate = delegate
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLabels()
    }

    private func commonInit() {
        tag = SettingsPicker.interval.rawValue
        backgroundColor = UIColor(named: AssetsColor.secondaryBackground.rawValue)
        
        let font = UIFont.systemFont(ofSize: 21.0)
        
        minuteLabel = UILabel()
        minuteLabel.font = font
        minuteLabel.textAlignment = .left
        minuteLabel.text = "min"
        minuteLabel.textColor = UIColor.secondaryLabel
        addSubview(minuteLabel)
        
        secondLabel = UILabel()
        secondLabel.font = font
        secondLabel.textAlignment = .left
        secondLabel.text = "sec"
        secondLabel.textColor = UIColor.secondaryLabel
        addSubview(secondLabel)
    }
    
    private func layoutLabels() {
        let fontSize = minuteLabel.font.pointSize
        let componentWidth = frame.width / CGFloat(numberOfComponents)
        let y = (frame.size.height / 2) - (fontSize / 2)
        
        let minuteComponentPosition = CGFloat(IntervalPickerComponent.minValue.rawValue)
        let secondComponentPosition = CGFloat(IntervalPickerComponent.secValue.rawValue)
        
        minuteLabel.frame = CGRect(x: componentWidth * (minuteComponentPosition + 0.7), y: y, width: componentWidth * 0.4, height: fontSize)
        
        secondLabel.frame = CGRect(x: componentWidth * (secondComponentPosition + 0.75), y: y, width: componentWidth * 0.4, height: fontSize)
    }
}
