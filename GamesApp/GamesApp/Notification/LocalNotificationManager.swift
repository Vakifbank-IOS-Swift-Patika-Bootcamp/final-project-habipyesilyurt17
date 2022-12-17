//
//  LocalNotificationManager.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 17.12.2022.
//

import Foundation
import UserNotifications
import UIKit

struct LocalNotification {
    var id: String
    var title: String
    var body: String
}

enum LocalNotificationDurationType {
    case days
    case hours
    case minutes
    case seconds
}

struct LocalNotificationManager {
    static let shared = LocalNotificationManager()
    static private var notifications = [LocalNotification]()

    static private func requestPermission() -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { success, error in
            if success == true && error == nil {
                // we have permission
            }
        }
    }
    
    static private func addNotification(title: String, body: String) -> Void {
        notifications.append(LocalNotification(id: UUID().uuidString, title: title, body: body))
    }
    
    static private func scheduleNotifications(_ durationInSeconds: Int, repeats: Bool) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body  = notification.body
            content.sound = UNNotificationSound.default
            content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(durationInSeconds), repeats: repeats)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
            }
        }
        notifications.removeAll()
    }
    
    static private func scheduleNotifications(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool) {
        var seconds = 0
        switch type {
        case .seconds:
            seconds = duration
        case .minutes:
            seconds = duration * 60
        case .hours:
            seconds = duration * 60 * 60
        case .days:
            seconds = duration * 60 * 60 * 24
        }
        scheduleNotifications(seconds, repeats: repeats)
    }
    
    func setNotification(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, title: String, body: String) {
        LocalNotificationManager.requestPermission()
        LocalNotificationManager.addNotification(title: title, body: body)
        LocalNotificationManager.scheduleNotifications(duration, of: type, repeats: repeats)
    }
    
}
