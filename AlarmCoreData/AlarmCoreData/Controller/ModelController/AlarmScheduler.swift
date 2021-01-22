//
//  AlarmScheduler.swift
//  AlarmCoreData
//
//  Created by Lee McCormick on 1/21/21.
//

import UserNotifications

// MARK: - Protocol
protocol AlarmScheduler: AnyObject {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    
   // weak var delegate: AlarmScheduler?
    
    func scheduleUserNotifications(for alarm: Alarm) {
        //delegate?.scheduleUserNotifications(for: alarm)
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
       // delegate?.cancelUserNotifications(for: alarm)
        guard let id = alarm.uuidString else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

/*

 e.

 Navigate back to your model controller and conform your AlarmController Class to the AlarmScheduler protocol. Notice how the compiler does not make you implement the schedule and cancel functions from the protocol? This is because by adding an extension to the protocol, we have created default implementation of these functions for all classes that conform to the protocol.
 Go through each of the CRUD functions and schedule / cancel the User Notifications based on the needs of that method.
 When an alarm is created it will need the alert scheduled.
 When an alarm is updated, cancel the first alert and then schedule the new one after the update is applied.
 When the alarm is enabled and disabled, handle the notifications accordingly
 When an alarm is deleted, we need to cancel the alert
 UNUserNotificationCenterDelegate
 The last thing you need to do is set up your app to notify the user when an alarm goes off and they still have the app open. In order to do this we are going to use the UNUserNotificationCenterDelegate protocol.

 In your application(_:didFinishLaunchingWithOptions:) function, set the delegate of the notification center to equal self.
 note: UNUserNotificationCenter.current().delegate = self
 Then call the delegate method userNotificationCenter(_:willPresent:withCompletionHandler:) and use the completionHandler to set your UNNotificationPresentationOptions.
 note: completionHandler([.alert, .sound])
 Build and run the app. Check for bugs. At this time, you should have a full working application that used a Protocol and Delegate, a custom Protocol, and uses local alerts. Well done!


 
 
 */
