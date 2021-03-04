//
//  RatioPickerView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/4/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

protocol ToolBarPickerViewDelegate: class {
    func didTapDone(_ picker: UIPickerView)
    func didTapDefault(_ picker: UIPickerView)
}

class RatioPickerView: UIPickerView {
    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolBarPickerViewDelegate?
    public private(set) var pickerDataSource: PickerDataSource?
    private var antecedentLabel: UILabel!
    private var colonLabel: UILabel!
    private var decimalLabel: UILabel!
    
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
        
        antecedentLabel = initLabel(text: "1")
        addSubview(antecedentLabel)
        
        colonLabel = initLabel(text: ":")
        addSubview(colonLabel)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        decimalLabel = initLabel(text: numberFormatter.decimalSeparator)
        addSubview(decimalLabel)
        
        toolbar = initToolbar()
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
    
    private func initToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        toolbar.barTintColor = UIColor(named: AssetsColor.secondaryBackground.rawValue)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let defaultButton = UIBarButtonItem(title: "Default", style: .plain, target: self, action: #selector(defaultTapped))
        
        toolbar.setItems([defaultButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
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
    
    @objc func doneTapped() {
        toolbarDelegate?.didTapDone(self)
    }
    
    @objc func defaultTapped() {
        toolbarDelegate?.didTapDefault(self)
    }
}
