//
//  WalkthroughContentVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/30/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughContentVC: UIViewController {

    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    var recipe: Recipe?
    
    var stepText: String?
    var amountText: String?
    var index: Int?
    
    var startIsHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepLabel.text = stepText
        amountLabel.text = amountText

        //round button
        startButton.layer.cornerRadius = 25
        if startIsHidden {
            startButton.isHidden = true
        } else {
            startButton.isHidden = false
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipe = recipe {
            let vc = segue.destination as! TimerVC
            vc.recipe = recipe
        }
    }
    

}
