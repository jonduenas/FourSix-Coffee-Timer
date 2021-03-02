//
//  RecipeBarChart.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/22/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class RecipeBarChart: UIView {
    @IBOutlet weak var barChartStack: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createBarChart(for recipe: Recipe) {
        let colorArray = UIColor.barChartColors()
        
        for (index, pour) in recipe.waterPours.reversed().enumerated() {
            guard colorArray.count >= index else { return }
            
            let view = createPourView(frame: .zero, backgroundColor: colorArray[index])
            
            switch index {
            case 0:
                // Rounds top corners
                view.layer.maskedCorners = [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner]
            case recipe.waterPours.count - 1:
                // Rounds bottom corners
                view.layer.maskedCorners = [CACornerMask.layerMinXMaxYCorner, CACornerMask.layerMaxXMaxYCorner]
            default:
                view.layer.maskedCorners = []
            }
            
            barChartStack.addArrangedSubview(view)
            
            view.widthAnchor.constraint(equalTo: barChartStack.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: barChartStack.heightAnchor, multiplier: CGFloat(pour / recipe.waterTotal), constant: -barChartStack.spacing).isActive = true
            
            let label = createValueLabel(for: pour)
            view.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
        }
    }
    
    private func createPourView(frame: CGRect, backgroundColor: UIColor?) -> UIView {
        let view = UIView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 10
        return view
    }
    
    private func createValueLabel(for value: Float) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = value.clean + "g"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(white: 0.9, alpha: 1)
        return label
    }
}
