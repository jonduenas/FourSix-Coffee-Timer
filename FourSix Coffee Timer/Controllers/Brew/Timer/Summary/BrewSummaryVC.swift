//
//  BrewSummaryVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 8/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class BrewSummaryVC: UIViewController, Storyboarded {
    var dataManager: DataManager?
    var recipe: Recipe?
    var session: Session?
    weak var coordinator: TimerCoordinator?
    
    // MARK: IBOutlets
    
    @IBOutlet var drawdownLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
    }
    
    private func createNewNoteForLater() {
        guard let recipe = recipe, let session = session else { return }
        dataManager?.newNoteMO(session: session, recipe: recipe, coffee: nil)
    }
    
    private func updateLabels() {
        guard let session = session else { fatalError("Nil value for session.") }
        
        drawdownLabel.text = "\(session.averageDrawdown().clean)s"
        totalTimeLabel.text = "\(session.totalTime.stringFromTimeInterval())"
    }
    
    @IBAction func didTapEnterDetails(_ sender: UIButton) {
        guard let recipe = recipe, let session = session else { return }
        dismiss(animated: true) {
            self.coordinator?.showNewNote(recipe: recipe, session: session)
        }
    }
    @IBAction func didTapLater(_ sender: UIButton) {
        dismiss(animated: true) {
            self.createNewNoteForLater()
            self.coordinator?.didFinishSummary()
        }
    }
}
