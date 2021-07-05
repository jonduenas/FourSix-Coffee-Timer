//
//  CoffeePickerView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/9/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class CoffeePickerView: RoundedView {

    @IBOutlet weak var coffeeDivider: UIView!
    @IBOutlet weak var addCoffeeStack: UIStackView!
    @IBOutlet weak var addCoffeeLabel: UILabel!
    @IBOutlet weak var addCoffeeImage: UIImageView!
    @IBOutlet weak var coffeeNameLabel: UILabel!
    @IBOutlet weak var roasterLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var roastLevelLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var chevronImage: UIImageView!

    var coffee: CoffeeMO? = nil {
        didSet {
            if coffee == nil {
                showNewCoffeePicker(true)
            } else {
                showNewCoffeePicker(false)
                updateCoffeeLabels(coffee!)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        showNewCoffeePicker(true)
    }

    private func showNewCoffeePicker(_ shouldShow: Bool) {
        addCoffeeStack.isHidden = !shouldShow
        coffeeNameLabel.isHidden = shouldShow
        coffeeDivider.isHidden = shouldShow
        roasterLabel.isHidden = shouldShow
        originLabel.isHidden = shouldShow
        roastLevelLabel.isHidden = shouldShow
        processLabel.isHidden = shouldShow
    }

    private func updateCoffeeLabels(_ coffee: CoffeeMO) {
        coffeeNameLabel.text = coffee.name
        roasterLabel.text = "Roaster: \(coffee.roaster)"

        let unknownString = "Unknown"

        let origin = coffee.origin == "" ? unknownString : coffee.origin
        originLabel.text = "Origin: \(origin)"

        let roastLevel = coffee.roastLevel == "" ? unknownString : coffee.roastLevel
        roastLevelLabel.text = "Roast Level: \(roastLevel)"

        processLabel.text = "Process: \(unknownString)"
    }

    func updateCoffeeLabels() {
        guard let coffee = coffee else { return }
        updateCoffeeLabels(coffee)
    }
}
