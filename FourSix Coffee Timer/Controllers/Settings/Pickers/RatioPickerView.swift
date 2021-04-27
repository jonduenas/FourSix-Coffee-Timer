//
//  RatioPickerView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/4/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

protocol ToolBarPickerViewDelegate: AnyObject {
    func didTapDone(_ picker: UIPickerView)
    func didTapDefault(_ picker: UIPickerView)
}

class RatioPickerView: UIPickerView {
    public private(set) var toolbar: PickerToolbar?
    public weak var toolbarDelegate: ToolBarPickerViewDelegate?
    private var antecedentLabel: UILabel!
    private var colonLabel: UILabel!
    private var decimalLabel: UILabel!
    
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
        tag = SettingsPicker.ratio.rawValue
        backgroundColor = UIColor(named: AssetsColor.secondaryBackground.rawValue)
        
        antecedentLabel = initLabel(text: "1")
        addSubview(antecedentLabel)
        
        colonLabel = initLabel(text: ":")
        addSubview(colonLabel)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        decimalLabel = initLabel(text: numberFormatter.decimalSeparator)
        addSubview(decimalLabel)
        
        toolbar = PickerToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44),
                                pickerView: self,
                                delegate: toolbarDelegate)
    }
    
    private func initLabel(text: String) -> UILabel {
        let font = UIFont.systemFont(ofSize: 21.0)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textAlignment = .left
        label.text = text
        label.textColor = UIColor.secondaryLabel
        return label
    }
    
    private func layoutLabels() {
        let fontSize = antecedentLabel.font.pointSize
        let componentWidth: CGFloat = frame.width / CGFloat(numberOfComponents)
        let y = (frame.size.height / 2) - (fontSize / 2)
        
        let antecedentComponentPosition = CGFloat(RatioPickerComponent.antecedent.rawValue)
        let colonComponentPosition = CGFloat(RatioPickerComponent.colon.rawValue)
        let decimalComponentPosition = CGFloat(RatioPickerComponent.decimal.rawValue)
        
        antecedentLabel.frame = CGRect(x: componentWidth * (antecedentComponentPosition + 0.5), y: y, width: componentWidth * 0.4, height: fontSize)
        
        colonLabel.frame = CGRect(x: componentWidth * (colonComponentPosition + 0.5), y: y, width: componentWidth * 0.4, height: fontSize)
        
        decimalLabel.frame = CGRect(x: componentWidth * (decimalComponentPosition + 0.5), y: y, width: componentWidth * 0.4, height: fontSize)
    }
}
