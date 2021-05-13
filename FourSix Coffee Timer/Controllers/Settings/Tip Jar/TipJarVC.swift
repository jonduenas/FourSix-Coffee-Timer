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
    @IBOutlet weak var closeButton: RoundButton!
    
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
        tipView.tipPriceButton.sizeToFit()
        tipView.tipPriceButton.tag = index
        tipView.tipPriceButton.addTarget(self, action: #selector(didTapTipButton(sender:)), for: .touchUpInside)
        
        tipStackView.addArrangedSubview(tipView)
    }
    
    @objc private func didTapTipButton(sender: LoadingButton) {
        setState(loading: true, button: sender, animated: true)
        
        let tipPackage = IAPManager.shared.tipPackages[sender.tag]
        
        IAPManager.shared.purchase(package: tipPackage) { [weak self] succeeded, error in
            guard let self = self else { return }
            
            self.setState(loading: false, button: sender, animated: true)
            
            if succeeded {
                AlertHelper.showConfirmationAlert(
                    title: "Tip Received",
                    message: """
                        👏 You're the true hero 👏
                        Thanks so much!
                        """,
                    confirmButtonTitle: "OK",
                    on: self)
            } else {
                if let error = error {
                    AlertHelper.showAlert(
                        title: "Tipping Failed",
                        message: "Error: \(error). Please try again.",
                        on: self)
                }
            }
        }
    }
    
    private func setState(loading: Bool, button: LoadingButton, animated: Bool) {
        switch (loading, animated) {
        case (true, true):
            UIView.animate(withDuration: 0.25) {
                button.showLoading()
                self.view.layoutIfNeeded()
            }
        case (true, false):
            button.showLoading()
        case (false, true):
            UIView.animate(withDuration: 0.25) {
                button.hideLoading()
                self.view.layoutIfNeeded()
            }
        case (false, false):
            button.hideLoading()
        }
        
        closeButton.isEnabled = !loading
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
