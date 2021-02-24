//
//  RecipeVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import Charts

class RecipeVC: UIViewController, Storyboarded {
    var recipe: Recipe!
    var labelArray = [UILabel]()
    weak var coordinator: BrewCoordinator?
    
    @IBOutlet var totalCoffeeWaterLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    
    @IBOutlet weak var barChartView: RecipeBarChart!
    @IBOutlet weak var recipeBarDetailView: RecipeBarDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBar()
        updateLabels()
        loadGraph()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateDetails()
    }
    
    private func initNavBar() {
        title = "Recipe"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(xButtonTapped))
    }
    
    private func updateLabels() {
        footerLabel.text = "Pour the amounts shown every \(recipe.interval.clean) seconds, allowing the water to drain completely between each pour."
        
        totalCoffeeWaterLabel.text = recipe.coffee.clean + "g coffee : " + recipe.waterTotal.clean + "g water"
    }
    
    private func loadGraph() {
        let entry = BarChartDataEntry(x: 1.0, yValues: recipe.waterPours.map { Double($0) })
        
        let dataSet = BarChartDataSet(entries: [entry])
        dataSet.setRecipeGraphPreferences()

        let data = BarChartData(dataSets: [dataSet])
        barChartView.data = data
        barChartView.setBarDataPreferences()

        barChartView.notifyDataSetChanged()
    }
    
//    @IBAction func startTapped(_ sender: Any) {
//        coordinator?.showTimer(for: recipe)
//    }
    
    @objc private func xButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func animateDetails() {
        if recipeBarDetailView.isHidden {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeLinear) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) { [unowned self] in
                    self.recipeBarDetailView.isHidden = false
                }
                UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) { [unowned self] in
                    self.recipeBarDetailView.alpha = 1
                }
            }
        }
    }
}
