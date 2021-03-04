//
//  IntervalPickerView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/4/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class IntervalPickerView: UIPickerView {
    public private(set) var toolbar: PickerToolbar?
    public weak var toolbarDelegate: ToolBarPickerViewDelegate?
    var minuteLabel: UILabel!
    var secondLabel: UILabel!
    
    init(frame: CGRect, dataSource: UIPickerViewDataSource, delegate: UIPickerViewDelegate, toolbarDelegate: ToolBarPickerViewDelegate) {
        super.init(frame: frame)
        self.dataSource = dataSource
        self.delegate = delegate
        self.toolbarDelegate = toolbarDelegate
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
        
        minuteLabel = initLabel(text: "min")
        addSubview(minuteLabel)
        
        secondLabel = initLabel(text: "sec")
        addSubview(secondLabel)
        
        toolbar = PickerToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44),
                                pickerView: self,
                                delegate: toolbarDelegate)
    }
    
    private func initLabel(text: String) -> UILabel {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 21.0)
        label.font = font
        label.textAlignment = .left
        label.text = text
        label.textColor = UIColor.secondaryLabel
        return label
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
