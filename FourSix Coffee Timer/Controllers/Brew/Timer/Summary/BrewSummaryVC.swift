//
//  BrewSummaryVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 8/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class BrewSummaryVC: UIViewController, Storyboarded {
    var recipe: Recipe?
    var session: Session?
    weak var coordinator: TimerCoordinator?
    
    // MARK: IBOutlets
    
    @IBOutlet var drawdownLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBar()
        updateLabels()
    }
    
    private func initNavBar() {
        title = "Brew Summary"
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    private func updateLabels() {
        guard let session = session else { fatalError("Nil values for session or recipe.") }
        
        drawdownLabel.text = "\(session.averageDrawdown().clean)s"
        
        totalTimeLabel.text = "\(session.totalTime.stringFromTimeInterval())"
    }
    
    @objc private func doneTapped() {
        dismiss(animated: true) { [weak self] in
            self?.coordinator?.didFinishSummary()
            AppStoreReviewManager.requestReviewIfAppropriate()
        }
    }
    
    @IBAction func didTapEnterDetails(_ sender: UIButton) {
        guard let recipe = recipe, let session = session else { return }
        coordinator?.showNewNote(recipe: recipe, session: session)
    }
}
