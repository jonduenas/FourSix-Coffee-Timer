//
//  NotesTextView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/22/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class NotesTextView: UITextView {
    private var editMode: Bool = false {
        didSet {
            layer.backgroundColor = editMode ? editOnColor?.cgColor : editOffColor?.cgColor
            layer.borderWidth = editMode ? 0.5 : 0
            isEditable = editMode
        }
    }
    
    private var editOnColor: UIColor? = UIColor(named: AssetsColor.background.rawValue)
    private var editOffColor: UIColor? = UIColor(named: AssetsColor.background.rawValue)
    
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
        layer.borderWidth = 0
        clipsToBounds = true
        layer.backgroundColor = editOffColor?.cgColor
        isEditable = false
        
        textContainerInset = UIEdgeInsets(top: 15, left: 8, bottom: 15, right: 8)
    }
    
    func setToEditMode(_ shouldSetToEdit: Bool) {
        guard editMode != shouldSetToEdit else { return }
        
        editMode = shouldSetToEdit
    }
    
    // Fix colors when switching between System Light and Dark Mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
    
    private func updateColors() {
        layer.backgroundColor = editMode ? editOnColor?.cgColor : editOffColor?.cgColor
    }
}
