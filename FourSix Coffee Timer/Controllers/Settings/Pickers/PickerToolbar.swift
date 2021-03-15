//
//  PickerToolbar.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/4/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class PickerToolbar: UIToolbar {
    public weak var toolbarDelegate: ToolBarPickerViewDelegate?
    public weak var pickerView: UIPickerView?
    
    init(frame: CGRect, pickerView: UIPickerView, delegate: ToolBarPickerViewDelegate?) {
        super.init(frame: frame)
        self.toolbarDelegate = delegate
        self.pickerView = pickerView
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
    
    private func commonInit() {
        barStyle = .default
        isTranslucent = true
        tintColor = UIColor(named: AssetsColor.accent.rawValue)
        barTintColor = UIColor(named: AssetsColor.secondaryBackground.rawValue)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let defaultButton = UIBarButtonItem(title: "Default", style: .plain, target: self, action: #selector(defaultTapped))
        
        setItems([defaultButton, spaceButton, doneButton], animated: false)
        isUserInteractionEnabled = true
    }
    
    @objc func doneTapped() {
        guard let picker = pickerView else { return }
        toolbarDelegate?.didTapDone(picker)
    }
    
    @objc func defaultTapped() {
        guard let picker = pickerView else { return }
        toolbarDelegate?.didTapDefault(picker)
    }
}
