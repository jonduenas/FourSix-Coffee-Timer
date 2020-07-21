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
    @IBOutlet var graphView: UIStackView!
    @IBOutlet var graphHiderHeight: NSLayoutConstraint!
    @IBOutlet var graphHiderView: UIView!
    
    @IBOutlet var pour6Graph: RoundGraphTop!
    @IBOutlet var pour5Graph: RoundGraphTop!
    @IBOutlet var pour4Graph: RoundGraphTop!
    
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
    
    let roundedCorner: CGFloat = 8
    
    let recipe: Recipe
    
    init?(coder: NSCoder, recipe: Recipe) {
        self.recipe = recipe
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearNavigationBar()

        labelArray = [pour1Label, pour2Label, pour3Label, pour4Label, pour5Label, pour6Label]
        
        totalCoffeeWaterLabel.text = recipe.coffee.clean + "g coffee : " + recipe.waterTotal.clean + "g water"
        
        loadGraph()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateGraph()
    }
    
    func loadGraph() {
        if recipe.balance == .sweet {
            pour1Height.constant = 60
            pour2Height.constant = 100
            view.layoutIfNeeded()
        } else if recipe.balance == .neutral {
            pour1Height.constant = 80
            pour2Height.constant = 80
            view.layoutIfNeeded()
        } else if recipe.balance == .bright {
            pour1Height.constant = 100
            pour2Height.constant = 60
            view.layoutIfNeeded()
        }
        
        if recipe.strength == .light {
            pour5View.isHidden = true
            pour6View.isHidden = true
            pour4Graph.cornerRadius = roundedCorner
            labelArray.removeLast(2)
        } else if recipe.strength == .medium {
            pour6View.isHidden = true
            pour5Graph.cornerRadius = roundedCorner
            pour4Graph.cornerRadius = 0
            labelArray.removeLast()
        } else {
            pour5Graph.cornerRadius = 0
            pour4Graph.cornerRadius = 0
        }
        
        for (index, label) in labelArray.enumerated() {
            label.text = recipe.waterPours[index].clean + "g"
        }
    }
    
    func animateGraph() {
        view.layoutIfNeeded()
        self.graphHiderHeight.constant = 0
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.33) {
                self.brace40Stack.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.33) {
                self.brace60Stack.alpha = 1
            }
        })
    }
    
    @IBAction func startTapped(_ sender: Any) {
        
    }
    
    // MARK: - Navigation

    @IBSegueAction
    func makeTimerViewController(coder: NSCoder) -> UIViewController? {
        TimerVC(coder: coder, recipe: recipe)
    }
    
    @IBAction func closeTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
