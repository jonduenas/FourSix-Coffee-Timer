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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recipe"
        updateLabels()
        loadGraph()
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
    
    @IBAction func startTapped(_ sender: Any) {
        coordinator?.showTimer(for: recipe)
    }
}
