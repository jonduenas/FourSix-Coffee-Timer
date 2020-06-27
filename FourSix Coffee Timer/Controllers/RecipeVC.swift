//
//  RecipeVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/26/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class RecipeVC: UIViewController {

    @IBOutlet var totalCoffeeWaterLabel: UILabel!
    
    @IBOutlet var pour1View: UIStackView!
    @IBOutlet var pour2View: UIStackView!
    @IBOutlet var pour3View: UIStackView!
    @IBOutlet var pour4View: UIStackView!
    @IBOutlet var pour5View: UIStackView!
    @IBOutlet var pour6View: UIStackView!
    
    @IBOutlet var pour1Height: NSLayoutConstraint!
    @IBOutlet var pour2Height: NSLayoutConstraint!
    @IBOutlet var graphHeight: NSLayoutConstraint!
    @IBOutlet var graphView: UIStackView!
    
    @IBOutlet var pour1Label: UILabel!
    @IBOutlet var pour2Label: UILabel!
    @IBOutlet var pour3Label: UILabel!
    @IBOutlet var pour4Label: UILabel!
    @IBOutlet var pour5Label: UILabel!
    @IBOutlet var pour6Label: UILabel!
    
    @IBOutlet var stack40: UIStackView!
    @IBOutlet var stack60: UIStackView!
    
    var labelArray = [UILabel]()
    
    var recipe: Recipe?
    var recipeWaterPours = [Double]()
    var recipeTotalWater: Double = 0
    var recipeTotalCoffee: Double = 0
    var recipeStrength: Strength = .medium
    var recipeBalance: Balance = .neutral
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelArray = [pour1Label, pour2Label, pour3Label, pour4Label, pour5Label, pour6Label]
        
        loadRecipe()
        loadGraph()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func loadRecipe() {
        recipeTotalCoffee = recipe?.coffee ?? 20
        recipeTotalWater = recipe?.waterTotal ?? 300
        recipeWaterPours = recipe?.waterPours ?? [60, 60, 60, 60, 60]
        
        totalCoffeeWaterLabel.text = recipeTotalCoffee.clean + "g coffee : " + recipeTotalWater.clean + "g water"
        
        recipeBalance = recipe?.balance ?? .neutral
        recipeStrength = recipe?.strength ?? .medium
    }
    
    func loadGraph() {
        if recipeBalance == .sweet {
            pour1Height.constant = 60
            pour2Height.constant = 100
            view.layoutIfNeeded()
        } else if recipeBalance == .neutral {
            pour1Height.constant = 80
            pour2Height.constant = 80
            view.layoutIfNeeded()
        } else if recipeBalance == .bright {
            pour1Height.constant = 100
            pour2Height.constant = 60
            view.layoutIfNeeded()
        }
        
        if recipeStrength == .light {
            pour5View.isHidden = true
            pour6View.isHidden = true
            labelArray.removeLast(2)
        } else if recipeStrength == .medium {
            pour6View.isHidden = true
            labelArray.removeLast()
        }
        
        for (index, label) in labelArray.enumerated() {
            label.text = recipeWaterPours[index].clean + "g"
        }
    }
    
    @IBAction func startTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Timer") as TimerVC
        
        let nc = UINavigationController(rootViewController: vc)
        
        nc.modalPresentationStyle = .fullScreen
        nc.navigationBar.tintColor = UIColor(named: "Accent")
        
        vc.recipe = recipe
        vc.recipeWater = recipeWaterPours
        
        present(nc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
