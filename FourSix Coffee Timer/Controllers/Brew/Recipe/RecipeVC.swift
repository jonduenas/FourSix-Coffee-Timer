//
//  RecipeVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class RecipeVC: UIViewController, Storyboarded {
    weak var coordinator: BrewCoordinator?
    var recipe: Recipe!
    
    @IBOutlet weak var totalCoffeeWaterLabel: UILabel!
    @IBOutlet weak var subheadLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    
    @IBOutlet weak var barChartView: RecipeBarChart!
    @IBOutlet weak var recipeBarDetailView: RecipeBarDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBar()
        updateLabels()
        initBarChart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateDetails()
    }
    
    private func initNavBar() {
        title = "Recipe"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(xButtonTapped))
    }
    
    private func updateLabels() {
        totalCoffeeWaterLabel.font = .preferredFont(for: .title2, weight: .semibold)
        totalCoffeeWaterLabel.text = recipe.coffee.clean + "g coffee : " + recipe.waterTotal.clean + "g water"
        subheadLabel.text = "Pour water every \(recipe.interval.clean) seconds"
    }
    
    private func initBarChart() {
        barChartView.delegate = self
        barChartView.createBarChart(for: recipe)
    }
    
    private func animateDetails() {
        guard recipeBarDetailView.isHidden || recipeBarDetailView.alpha == 0 else { return }
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeLinear) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) { [unowned self] in
                self.recipeBarDetailView.isHidden = false
            }
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) { [unowned self] in
                self.recipeBarDetailView.alpha = 1
            }
        }
    }
    
    @objc private func xButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RecipeVC: RecipeBarChartDelegate {
    func recipeBarChart(_ recipeBarChart: RecipeBarChart, didSelect section: Int) {
        var newLabelString = "Pour \(section + 1): "
        
        switch section {
        case 0:
            newLabelString += "A larger pour results in a brighter, more acidic cup."
        case 1:
            newLabelString += "A larger pour results in a sweeter, less acidic cup."
        case 2...6:
            newLabelString += "Dividing the remaining 60% into more pours results in higher extraction strength. Fewer pours extracts less and results in a lighter cup."
        default:
            break
        }
        
        UIView.transition(with: footerLabel,
                          duration: 0.3,
                          options: .transitionCrossDissolve) {
            self.footerLabel.text = newLabelString
        }
    }
}
