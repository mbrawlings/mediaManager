//
//  NotificationScheduler.swift
//  MediaManager
//
//  Created by Matthew Rawlings on 10/7/22.
//

import UserNotifications

class NotificationScheduler {
    func scheduleNotifications(mediaItem: MediaItem) {
        guard let id = mediaItem.id?.uuidString,
              let reminderDate = mediaItem.reminderDate else { return }
        clearNotifications(mediaItem: mediaItem)
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don't forget to watch \(mediaItem.title ?? "--missing movie/show title--")"
        content.sound = .default
        content.categoryIdentifier = "MediaItemNotification"
        
        let fireDateComponents = Calendar.current.dateComponents([.year, .month, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Unable to add notification request, \(error.localizedDescription)")
            }
        }
    }
    
    func clearNotifications(mediaItem: MediaItem) {
        guard let id = mediaItem.id?.uuidString else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
