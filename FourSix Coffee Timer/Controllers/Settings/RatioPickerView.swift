//
//  RatioPickerView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/4/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class RatioPickerView: UIPickerView {
    var pickerDataSource: PickerDataSource?
    var antecedentLabel: UILabel!
    var colonLabel: UILabel!
    var decimalLabel: UILabel!
    
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
        tag = SettingsPicker.ratio.rawValue
        backgroundColor = UIColor(named: AssetsColor.secondaryBackground.rawValue)
        
        let font = UIFont.systemFont(ofSize: 21.0)
        
        antecedentLabel = UILabel()
        antecedentLabel.font = font
        antecedentLabel.textAlignment = .left
        antecedentLabel.text = "1"
        antecedentLabel.textColor = UIColor.secondaryLabel
        addSubview(antecedentLabel)
        
        colonLabel = UILabel()
        colonLabel.font = font
        colonLabel.textAlignment = .left
        colonLabel.text = ":"
        colonLabel.textColor = UIColor.secondaryLabel
        addSubview(colonLabel)
        
        decimalLabel = UILabel()
        decimalLabel.font = font
        decimalLabel.textAlignment = .left
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        decimalLabel.text = numberFormatter.decimalSeparator
        decimalLabel.textColor = UIColor.secondaryLabel
        addSubview(decimalLabel)
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
