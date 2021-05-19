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
    @IBOutlet weak var doneLabel: UILabel!

    @IBOutlet var drawdownLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLabels()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !UserDefaultsManager.hasSeenNotificationRequest {
            AlertHelper.showRatingReminderAlert(on: self) { _ in
                UserDefaultsManager.hasSeenNotificationRequest = true
                self.setReminder()
            }
        } else {
            setReminder()
        }
    }

    private func createNewNoteForLater() {
        guard let recipe = recipe, let session = session else { return }
        dataManager?.newNoteMO(session: session, recipe: recipe, coffee: nil)
    }

    private func updateLabels() {
        guard let session = session else { fatalError("Nil value for session.") }

        doneLabel.font = UIFont.newYork(size: 36, weight: .bold)

        drawdownLabel.text = "\(session.averageDrawdown().clean)s"
        totalTimeLabel.text = "\(session.totalTime.stringFromTimeInterval())"
    }

    @IBAction func didTapEnterDetails(_ sender: UIButton) {
        guard let recipe = recipe, let session = session else { return }
        let newNote = dataManager?.newNoteMO(session: session, recipe: recipe, coffee: nil)

        dismiss(animated: true) {
            self.coordinator?.showNewNote(note: newNote)
        }
    }

    @IBAction func didTapLater(_ sender: UIButton) {
        dismiss(animated: true) {
            self.createNewNoteForLater()
            self.coordinator?.didFinishSummary()
        }
    }

    private func setReminder() {
        print("Setting reminder")
        let notificationManager = LocalNotificationManager()
        notificationManager.notifications = [LocalNotification.fiveMinuteRatingNotification]
        notificationManager.schedule()
    }
}
