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
        walkthroughImage.image = UIImage(named: walkthroughImageName)
    }

    @IBAction func didTapEnableNotificationsButton(_ sender: UIButton) {
        let manager = LocalNotificationManager()
        manager.checkCurrentAuthorization { permission in
            switch permission {
            case .authorized:
                self.showAuthorizedAlert()
            case .denied:
                self.showDeniedAlert()
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
                    If you change your mind, you can turn off notifications \
                    in Settings or revoke permission in your device settings.
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
