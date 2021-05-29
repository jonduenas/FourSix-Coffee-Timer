//
//  WalkthroughNotificationsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/24/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughNotificationsVC: WalkthroughContentVC {
    let notificationManager = LocalNotificationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationManager.delegate = self
        headerLabel.text = headerString
        footerLabel.text = footerString
        walkthroughImage.image = UIImage(named: walkthroughImageName)?.rounded(radius: 20)
    }

    @IBAction func didTapEnableNotificationsButton(_ sender: UIButton) {
        notificationManager.checkCurrentAuthorization { [weak self] permission in
            switch permission {
            case .authorized:
                self?.showAuthorizedAlert()
                UserDefaultsManager.sendReminderNotification = true
            case .denied:
                self?.showDeniedAlert()
                UserDefaultsManager.sendReminderNotification = false
            case .notDetermined:
                self?.notificationManager.schedule()
            }
        }
    }

    private func showAuthorizedAlert() {
        DispatchQueue.main.async {
            AlertHelper.showAlert(
                title: "Notifications Enabled",
                message: """
                    If you change your mind, you can always turn them off \
                    after a brew session, or revoke permission in device \
                    Settings > FourSix > Notifications.
                    """,
                on: self)
        }
    }

    private func showDeniedAlert() {
        DispatchQueue.main.async {
            AlertHelper.showAlert(
                title: "Notifications Disabled",
                message: """
                    You've previously denied FourSix permission to show \
                    you notifications. To change this, you will have to \
                    go to your device Settings > FourSix > Notifications \
                    and enable them there.
                    """,
                on: self)
        }
    }
}

extension WalkthroughNotificationsVC: LocalNotificationManagerDelegate {
    func notificationMananger(_ notificationManager: LocalNotificationManager, didChangePermission permission: NotificationPermission) {
        UserDefaultsManager.sendReminderNotification = permission == .authorized
    }
}
