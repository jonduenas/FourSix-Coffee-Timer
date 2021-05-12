//
//  TipJarVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/11/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class TipJarVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var tipStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for view in tipStackView.arrangedSubviews {
            tipStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for index in 1...3 {
            let tipView = TipView()
            tipView.tipLabel.text = "Test Tip \(index)"
            tipView.tipPriceButton.setTitle("$\(index)", for: .normal)
            tipView.translatesAutoresizingMaskIntoConstraints = false
            tipView.heightAnchor.constraint(equalToConstant: 44).isActive = true
            tipStackView.addArrangedSubview(tipView)
        }
    }
}
