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
    
    var stepText: String?
    var amountText: String?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepLabel.text = stepText
        amountLabel.text = amountText

        // Do any additional setup after loading the view.
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
