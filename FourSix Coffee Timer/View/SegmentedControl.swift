//
//  SegmentedControl.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/27/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

@IBDesignable
class SegmentedControl: UIControl {
    private var labels: [UILabel] = []
    var thumbView = UIView()
    
    var items: [String] = ["Item 1", "Item 2", "Item 3"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    @IBInspectable var selectedLabelColor: UIColor = .white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor: UIColor = .label {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor: UIColor = .systemBlue {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .darkGray {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var font: UIFont = .systemFont(ofSize: 14, weight: .medium) {
        didSet {
            setFont()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    func commonInit() {
        layer.cornerRadius = frame.height / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 2
        
        setupLabels()
        
        insertSubview(thumbView, at: 0)
    }
    
    
    func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            let label = UILabel()
            label.text = items[index - 1]
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = font
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(items: labels, mainView: self, padding: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        displayNewSelectedIndex()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        var calculatedIndex: Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if let newIndex = calculatedIndex {
            selectedIndex = newIndex
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex() {
        for label in labels {
            label.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseOut) {
            self.thumbView.frame = label.frame
        }
    }
    
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        
        for (index, button) in items.enumerated() {
            button.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
            
            button.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
            
            if index == items.count - 1 {
                button.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -padding).isActive = true
            } else {
                let nextButton = items[index + 1]
                button.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -padding).isActive = true
            }
            
            if index == 0 {
                button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: -padding).isActive = true
            } else {
                let prevButton = items[index - 1]
                button.leadingAnchor.constraint(equalTo: prevButton.trailingAnchor, constant: -padding).isActive = true
                
                let firstItem = items[0]
                button.widthAnchor.constraint(equalTo: firstItem.widthAnchor).isActive = true
            }
        }
    }
    
    func setFont() {
        for label in labels {
            label.font = font
        }
    }
    
    func setSelectedColors() {
        for label in labels {
            label.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
        layer.borderColor = borderColor.cgColor
    }
}
