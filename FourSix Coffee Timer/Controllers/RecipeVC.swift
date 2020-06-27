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
    @IBOutlet var graphHiderHeight: NSLayoutConstraint!
    @IBOutlet var graphHiderView: UIView!
    
    @IBOutlet var brace60Stack: UIStackView!
    @IBOutlet var brace40Stack: UIStackView!
    
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
        
        self.clearNavigationBar()

        labelArray = [pour1Label, pour2Label, pour3Label, pour4Label, pour5Label, pour6Label]
        
        loadRecipe()
        loadGraph()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateGraph()
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
    
    func animateGraph() {
        view.layoutIfNeeded()
        self.graphHiderHeight.constant = 0
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                self.view.layoutIfNeeded()
                //self.graphHiderView.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.33) {
                self.brace40Stack.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.33) {
                self.brace60Stack.alpha = 1
            }
        })
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
//            self.graphHiderHeight.constant = 0
//            self.graphHiderView.alpha = 0
//        }) { [weak self] _ in
//            self?.animateBraces()
//        }
    }
    
    @IBAction func startTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TimerVC
        vc.recipe = recipe
        vc.recipeWater = recipeWaterPours
    }
    
    @IBAction func closeTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
}
