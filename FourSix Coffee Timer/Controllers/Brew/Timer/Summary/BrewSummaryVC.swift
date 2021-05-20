//
//  BrewSummaryVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 8/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class BrewSummaryVC: UIViewController, Storyboarded {
    let notificationManager = LocalNotificationManager()

    var dataManager: DataManager?
    var recipe: Recipe?
    var session: Session?
    var newNote: NoteMO?
    weak var coordinator: TimerCoordinator?
    private var showNotification: Bool = UserDefaultsManager.sendReminderNotification {
        didSet {
            switch (showNotification, notificationManager.permission) {
            case (true, .authorized):
                UserDefaultsManager.sendReminderNotification = true
                setNotificationButtonImage(enabled: true)
            case (true, .denied), (true, .notDetermined):
                // Reverse setting to true if permission is not approved
                showNotification = false
            default:
                // Any remaining cases are showNotification == false
                UserDefaultsManager.sendReminderNotification = false
                self.setNotificationButtonImage(enabled: false)
            }
        }
    }

    // MARK: IBOutlets
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var drawdownLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        createNewNote()
        notificationManager.delegate = self
        updateLabels()
        setNotificationButtonImage(enabled: showNotification)

        if showNotification {
            setReminder()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        notificationButton.wiggle()
    }

    private func createNewNote() {
        guard let recipe = recipe, let session = session else { return }
        newNote = dataManager?.newNoteMO(session: session, recipe: recipe, coffee: nil)
    }

    private func updateLabels() {
        guard let session = session else { fatalError("Nil value for session.") }

        doneLabel.font = UIFont.newYork(size: 36, weight: .bold)

        drawdownLabel.text = "\(session.averageDrawdown().clean)s"
        totalTimeLabel.text = "\(session.totalTime.stringFromTimeInterval())"
    }

    @IBAction func didTapEnterDetails(_ sender: UIButton) {
        dismiss(animated: true) {
            guard let newNote = self.newNote else { return }
            self.coordinator?.showNewNote(note: newNote)
        }
    }

    @IBAction func didTapLater(_ sender: UIButton) {
        dismiss(animated: true) {
            self.coordinator?.didFinishSummary()
        }
    }

    private func setReminder() {
        notificationManager.checkCurrentAuthorization { authorization in
            if authorization == .denied {
                self.showPermissionDeniedAlert()
            } else {
                self.notificationManager.notifications = [LocalNotification.fiveMinuteRatingNotification]
                self.notificationManager.schedule()
            }
        }
    }

    private func showPermissionDeniedAlert() {
        DispatchQueue.main.async {
            AlertHelper.showAlert(
                title: "FourSix Can't Show Notifications",
                message: """
                    To enable notifications, you will have to go \
                    to your device Settings > FourSix > Notifications \
                    and grant permission there.

                    After selecting "Allow Notifications", return \
                    to FourSix and try again.
                    """,
                on: self)
        }
    }

    @IBAction func didTapNotificationButton(_ sender: UIButton) {
        if !UserDefaultsManager.hasSeenNotificationRequest && !showNotification {
            AlertHelper.showRatingReminderAlert(on: self) { _ in
                UserDefaultsManager.hasSeenNotificationRequest = true
                self.toggleShowNotification()
            }
        } else {
            toggleShowNotification()
        }
    }

    private func setNotificationButtonImage(enabled: Bool) {
        let notificationOn: UIImage? = UIImage(systemName: "bell.fill")
        let notificationOff: UIImage? = UIImage(systemName: "bell")

        let selectedImage = enabled ? notificationOn : notificationOff

        DispatchQueue.main.async {
            self.notificationButton.setImage(selectedImage, for: .normal)
        }
    }

    private func toggleShowNotification() {
        if !showNotification {
            // Current state is notifications off, so attempt to turn on
            setReminder()
        } else {
            // Turns off notifications and cancels all pending ones
            showNotification = false
            notificationManager.cancelPendingReminders()
        }
    }
}

extension BrewSummaryVC: LocalNotificationManagerDelegate {
    func notificationMananger(_ notificationManager: LocalNotificationManager, didChangePermission permission: NotificationPermission) {
        switch permission {
        case .authorized:
            showNotification = true
        case .denied, .notDetermined:
            showNotification = false
        }
    }
}
