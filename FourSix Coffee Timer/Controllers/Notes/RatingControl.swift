//
//  RatingControl.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/22/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

protocol RatingControlDelegate: AnyObject {
    func ratingControlShouldShowHint(ratingControl: RatingControl)
    func ratingControl(ratingControl: RatingControl, didChangeRating rating: Int)
    func ratingControlShouldChangeRating(_ ratingControl: RatingControl) -> Bool
}

extension RatingControlDelegate {
    func ratingControlShouldChangeRating(_ ratingControl: RatingControl) -> Bool {
        return true
    }
}

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

    var rating: Int = 0 {
        didSet {
            updateButtonSelectionStates()
            delegate?.ratingControl(ratingControl: self, didChangeRating: rating)
        }
    }

    weak var delegate: RatingControlDelegate?

    private var ratingButtons: [UIButton] = []
    private var offImage: UIImage? = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    private var onImage: UIImage? = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    private var onColor: UIColor? = UIColor(named: AssetsColor.accent.rawValue)
    private var offColor: UIColor? = UIColor(named: AssetsColor.accent.rawValue)
    private var enabledColor: UIColor? = UIColor(named: AssetsColor.accent.rawValue)
    @IBInspectable var disabledColor: UIColor? = UIColor.label {
        didSet {
            setupButtons()
        }
    }

    private var editMode: Bool = true {
        didSet {
            for button in ratingButtons {
                button.tintColor = editMode ? enabledColor : disabledColor
            }
        }
    }

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
        for index in 0..<starCount {
            let button = UIButton()

            button.tintColor = enabledColor

            button.setImage(offImage, for: .normal)
            button.setImage(onImage, for: .selected)
            button.setImage(onImage, for: .highlighted)
            button.adjustsImageWhenHighlighted = false

            // Action for single tap
            button.addTarget(self, action: #selector(ratingButtonTapped(sender:forEvent:)), for: .touchUpInside)

            // Action for long press
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ratingButtonLongTapped(sender:)))
            button.addGestureRecognizer(longGesture)

            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

            button.accessibilityLabel = "Set \(index + 1) star rating"

            addArrangedSubview(button)
            ratingButtons.append(button)
        }

        updateButtonSelectionStates()
    }

    // MARK: Button Action

    @objc private func ratingButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        guard editMode == true else {
            // If editMode is not enabled, should show hint for long pressing
            delegate?.ratingControlShouldShowHint(ratingControl: self)
            return
        }

        if delegate?.ratingControlShouldChangeRating(self) ?? true {
            setRating(for: sender)
        }
    }

    @objc private func ratingButtonLongTapped(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        guard let button = sender.view as? UIButton else { return }

        if delegate?.ratingControlShouldChangeRating(self) ?? true {
            setRating(for: button)
        }
    }

    private func setRating(for button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }

        let selectedRating = index + 1

        if selectedRating == rating {
            // Reset rating to 0  if user selects current rating
            rating = 0
        } else {
            rating = selectedRating
        }
    }

    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected
            button.isSelected = index < rating

            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }

            let valueString: String
            switch rating {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }

            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }

    func setToEditMode(_ shouldSetToEdit: Bool) {
        guard editMode != shouldSetToEdit else { return }

        editMode = shouldSetToEdit
    }
}
