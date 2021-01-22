//
//  AlarmScheduler.swift
//  AlarmCoreData
//
//  Created by Lee McCormick on 1/21/21.
//

import UserNotifications

// MARK: - Protocol
protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        guard let fireDate = alarm.fireDate,
              let id = alarm.uuidString else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "ALARM"
        content.body = "This is time for \(alarm.title ??  "alarm.")."
        content.sound = .default
        
        let dateComponent = Calendar.current.dateComponents([.hour,.minute], from: fireDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        guard let id = alarm.uuidString else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

