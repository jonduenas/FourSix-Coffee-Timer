//
//  NotesTextView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/22/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class NotesTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
        setToEditMode(false)
    }
    
    func setToEditMode(_ shouldSetToEdit: Bool) {
        if shouldSetToEdit {
            isEditable = true
            layer.backgroundColor = UIColor.systemBackground.cgColor
        } else {
            isEditable = false
            layer.backgroundColor = UIColor(named: AssetsColor.background.rawValue)?.cgColor
        }
    }
}
