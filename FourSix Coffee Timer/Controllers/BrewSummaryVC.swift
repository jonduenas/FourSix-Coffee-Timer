//
//  BrewSummaryVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 8/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class BrewSummaryVC: UIViewController {

    // MARK: Constants
    
    let recipe: Recipe
    let drawdownTimes: [TimeInterval]
    let totalTime: TimeInterval
    
    // MARK: IBOutlets
    
    @IBOutlet var subHeaderLabel: UILabel!
    @IBOutlet var recipeSubHeaderLabel: UILabel!
    @IBOutlet var recipeBreakdownLabel: UILabel!
    @IBOutlet var drawdownLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    
    init?(coder: NSCoder, recipe: Recipe, drawdownTimes: [TimeInterval], totalTime: TimeInterval) {
        self.recipe = recipe
        self.drawdownTimes = drawdownTimes
        self.totalTime = totalTime
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))

        updateLabels()
    }
    
    private func updateLabels() {
        let totalCoffee = recipe.coffee
        let totalWater = recipe.waterTotal
        
        subHeaderLabel.text = "\(totalCoffee.clean)g coffee : \(totalWater.clean)g water"
        
        let recipeBalance = "\(recipe.balance)"
        let recipeStrength = "\(recipe.strength)"
        
        recipeSubHeaderLabel.text = "\(recipeBalance.capitalized) & \(recipeStrength.capitalized)"
        
        let recipePours = recipe.waterPours
        let recipePoursStrings = recipePours.map { $0.clean + "g" }
        
        recipeBreakdownLabel.text = recipePoursStrings.joined(separator: " | ")
        
        let averageDrawdown = calculateAverageDrawdown(with: drawdownTimes)
        
        drawdownLabel.text = "\(averageDrawdown.clean)s"
        
        let totalTimeFormatted = totalTime.stringFromTimeInterval()
        
        totalTimeLabel.text = "\(totalTimeFormatted)"
    }
    
    private func calculateAverageDrawdown(with times: [TimeInterval]) -> TimeInterval {
        let averageTime = times.reduce(0, +) / Double(times.count)
        let roundedAverageTime = averageTime.rounded()
        
        return roundedAverageTime
    }
    
    @objc private func doneTapped() {
        self.dismiss(animated: true) {
            AppStoreReviewManager.requestReviewIfAppropriate()
        }
    }
}
