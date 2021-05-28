//
//  WalkthroughNotificationsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/24/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughNotificationsVC: WalkthroughContentVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text = headerString
        footerLabel.text = footerString
        walkthroughImage.image = UIImage(named: walkthroughImageName)?.rounded(radius: 20)
    }

    @IBAction func didTapEnableNotificationsButton(_ sender: UIButton) {
        let manager = LocalNotificationManager()
        manager.checkCurrentAuthorization { permission in
            switch permission {
            case .authorized:
                self.showAuthorizedAlert()
                UserDefaultsManager.sendReminderNotification = true
            case .denied:
                self.showDeniedAlert()
                UserDefaultsManager.sendReminderNotification = false
            case .notDetermined:
                manager.schedule()
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
