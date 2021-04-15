//
//  DoneToolBar+UITextField.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/23/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

extension UITextField {
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneToolbar()
            }
        }
    }
    
    func addDoneToolbar() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        doneToolbar.barStyle = .default
        doneToolbar.barTintColor = UIColor(named: AssetsColor.secondaryBackground.rawValue)
        doneToolbar.isTranslucent = false
        doneToolbar.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonTapped() {
        resignFirstResponder()
    }
}
