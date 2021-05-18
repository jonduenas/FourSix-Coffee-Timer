//
//  LocalNotificationManager.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/18/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    var notifications: [LocalNotification] = []

    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted && error == nil {
                self.scheduleNotifications()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    private func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.timeInterval, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Notification scheduled --- ID = \(notification.id)")
            }
        }
    }

    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
}

struct LocalNotification {
    var id: String
    var title: String
    var body: String
    var timeInterval: TimeInterval
}
