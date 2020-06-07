//
//  StartWalkthroughVC.swift
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
    
    var stepText: String?
    var amountText: String?
    var index: Int?
    var recipeWater = [Double]()
    var totalWater: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepLabel.text = stepText
        amountLabel.text = amountText

        //round button
        startButton.layer.cornerRadius = 25
        startButton.isHidden = true
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let vc = segue.destination as! TimerVC
         vc.recipeWater = recipeWater
         vc.totalWater = totalWater
    }
    

}
