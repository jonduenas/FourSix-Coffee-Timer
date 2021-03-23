//
//  RatingControl.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/22/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    var rating: Int = 0
    
    private var ratingButtons: [UIButton] = []
    private var offImage: UIImage? = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    private var onImage: UIImage? = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    private var onColor: UIColor? = UIColor(named: AssetsColor.accent.rawValue)
    private var offColor: UIColor? = UIColor(named: AssetsColor.accent.rawValue)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons() {
        // Clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // Creates new buttons
        for _ in 0..<starCount {
            let button = UIButton()
            button.setImage(offImage, for: .normal)
            button.setImage(onImage, for: .selected)
            button.tintColor = onColor
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
    
    // MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        print("Rating button tapped")
    }
}
