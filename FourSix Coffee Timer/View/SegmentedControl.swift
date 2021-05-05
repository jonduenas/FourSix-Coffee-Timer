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
    private var stackView = UIStackView()
    var thumbView = UIView()
    
    var items: [String] = ["Item 1", "Item 2", "Item 3"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex(animated: true)
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
    
    @IBInspectable var fontSize: CGFloat = 14 {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable var fontWeight: UIFont.Weight = .medium {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable var addShadow: Bool = false {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.25 {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 1.5) {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.5 {
        didSet {
            setShadow()
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
        
        setupStackView()
        setupLabels()
        
        insertSubview(thumbView, at: 0)
    }
    
    func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func setupLabels() {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        
        labels.removeAll()
        
        for index in 1...items.count {
            let label = UILabel()
            label.text = items[index - 1]
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            stackView.addArrangedSubview(label)
            labels.append(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        setShadow()
        displayNewSelectedIndex(animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        
        var calculatedIndex: Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if let newIndex = calculatedIndex, selectedIndex != newIndex {
            selectedIndex = newIndex
            sendActions(for: .valueChanged)
        }
    }
    
    func displayNewSelectedIndex(animated: Bool) {
        for label in labels {
            label.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        if animated {
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveEaseOut) {
                self.thumbView.frame = label.frame
            }
        } else {
            self.thumbView.frame = label.frame
        }
    }
    
    func setFont() {
        for label in labels {
            label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
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
    
    func setShadow() {
        if addShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = shadowOpacity
            layer.shadowOffset = shadowOffset
            layer.shadowRadius = shadowRadius
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.height / 2).cgPath
        } else {
            layer.shadowPath = nil
            layer.shadowColor = nil
            layer.shadowOpacity = 0
        }
    }
}
