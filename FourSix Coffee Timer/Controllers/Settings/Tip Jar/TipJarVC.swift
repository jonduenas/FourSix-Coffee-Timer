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
    
    var tips: [IAPurchase] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in tipStackView.arrangedSubviews {
            tipStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        loadTips()
    }
    
    private func loadTips() {
        IAPManager.shared.loadTips { [weak self] succeeded, error in
            guard let self = self else { return }
            
            if !succeeded, let error = error {
                AlertHelper.showAlert(title: "Error", message: error, on: self)
                return
            } else {
                let allTips = IAPManager.shared.tips
                for (index, tip) in allTips.enumerated() {
                    self.createTipView(for: tip, index: index)
                }
                self.tips = allTips
            }
        }
    }
    
    private func createTipView(for tip: IAPurchase, index: Int) {
        let tipView = TipView()
        tipView.tipLabel.text = tip.name
        tipView.tipPriceButton.setTitle(tip.localizedPriceString, for: .normal)
        tipView.tipPriceButton.tag = index
        tipView.tipPriceButton.addTarget(self, action: #selector(didTapTipButton(sender:)), for: .touchUpInside)
        
        tipStackView.addArrangedSubview(tipView)
    }
    
    @objc private func didTapTipButton(sender: UIButton) {
        let tipPackage = IAPManager.shared.tipPackages[sender.tag]
        
        IAPManager.shared.purchase(package: tipPackage) { succeeded, error in
            print(succeeded)
            print(error)
        }
    }
}
