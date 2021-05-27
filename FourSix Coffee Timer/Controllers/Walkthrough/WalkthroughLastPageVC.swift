//
//  WalkthroughLastPageVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/27/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughLastPageVC: UIViewController, Storyboarded {
    weak var coordinator: WalkthroughCoordinator?
    var listString = ""
    @IBOutlet weak var listLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        listLabel.text = listString
    }

    @IBAction func didTapCTAButton(_ sender: UIButton) {
        dismiss(animated: true) {
            self.coordinator?.didFinishWalkthrough()
        }
    }
}
