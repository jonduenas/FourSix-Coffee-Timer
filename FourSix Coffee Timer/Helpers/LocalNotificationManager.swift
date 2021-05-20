//
//  LocalNotificationManager.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/18/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationPermission {
    case notDetermined, authorized, denied
}

protocol LocalNotificationManagerDelegate: AnyObject {
    func notificationMananger(_ notificationManager: LocalNotificationManager, didChangePermission permission: NotificationPermission)
}

class LocalNotificationManager {
    weak var delegate: LocalNotificationManagerDelegate?
    var notifications: [LocalNotification] = []
    var permission: NotificationPermission = .notDetermined {
        didSet {
            delegate?.notificationMananger(self, didChangePermission: permission)
        }
    }

    func listScheduledNotifications() {
        // For debugging purposes
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            if notifications.isEmpty {
                print("No notifications scheduled")
            } else {
                for notification in notifications {
                    print(notification)
                }
            }
        }
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted && error == nil {
                self.permission = .authorized
                self.scheduleNotifications()
            } else if let error = error {
                print(error.localizedDescription)
            } else {
                self.permission = .denied
            }
        }
    }

    private func scheduleNotifications() {
        guard permission == .authorized else { return }

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
                self.permission = .authorized
                self.scheduleNotifications()
            default:
                break
            }
        }
    }

    func checkCurrentAuthorization(completion: @escaping (NotificationPermission) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.permission = .authorized
            case .denied:
                self.permission = .denied
            default:
                break
            }

            completion(self.permission)
        }
    }

    func cancelPendingReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        notifications.removeAll()
    }
}

struct LocalNotification {
    var id: String
    var title: String
    var body: String
    var timeInterval: TimeInterval

    static let fiveMinuteRatingNotification = LocalNotification(
        id: "fiveMinuteReminder",
        title: "Rate Your Coffee",
        body: "Your coffee should be at the perfect temperature. Time to add a rating.",
        timeInterval: 300
    )
}
