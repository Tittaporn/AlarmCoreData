//
//  AlarmController.swift
//  AlarmCoreData
//
//  Created by Lee McCormick on 1/21/21.
//

import CoreData

class AlarmController {
    
    // MARK: - Properties
    static let shared = AlarmController()
    var alarms: [Alarm] = []
    private lazy var fetchRequest : NSFetchRequest<Alarm> = {
        let request = NSFetchRequest<Alarm>(entityName: "Alarm")
        request.predicate = NSPredicate(value: true)
        return request
    }()
   
    weak var delegate: AlarmScheduler?
    //let alarmScheduler = AlarmScheduler()
    
    // MARK: - CRUD Methods
    // CREATE
    func createAlarm(withTitle title: String, fireDate: Date) {
        let newAlarm = Alarm(title: title, isEnabled: false, fireDate: fireDate)
        alarms.append(newAlarm)
        CoreDataStack.saveContext()
        //alarmScheduler.scheduleUserNotifications(for: newAlarm)
        //.scheduleUserNotifications(for: newAlarm)
        delegate?.scheduleUserNotifications(for: newAlarm)
    }
    
    // READ
    func fetchAlarms() {
        self.alarms = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        
    }
    
    // UPDATE
    func update(alarm: Alarm, newTitle: String, newFireDate: Date, isEnabled: Bool) {
        alarm.title = newTitle
        alarm.fireDate = newFireDate
        alarm.isEnabled = isEnabled
        CoreDataStack.saveContext()
        
        // cancel
        delegate?.cancelUserNotifications(for: alarm)
        //.scheduleUserNotifications(for: newAlarm)
        delegate?.scheduleUserNotifications(for: alarm)
    }
    
    func toggleIsEnabledFor(alarm: Alarm) {
        alarm.isEnabled.toggle()
        CoreDataStack.saveContext()
        
        if alarm.isEnabled {
            //.scheduleUserNotifications(for: newAlarm)
            delegate?.scheduleUserNotifications(for: alarm)
        } else {
            // cancel
            delegate?.cancelUserNotifications(for: alarm)
        }
    }
    
    // DELETE
    func delete(alarm: Alarm) {
//        guard let indexToDelete = alarms.firstIndex(of: alarm) else { return }
//        alarms.remove(at: indexToDelete)
        CoreDataStack.context.delete(alarm)
        CoreDataStack.saveContext()
        fetchAlarms()
        // cancel
        delegate?.cancelUserNotifications(for: alarm)
    }
    
    func saveToPersistenStore() {
        // I DON'T THINK I NEED THIS FUCNTION BECAUSE I HAVE COREDATASTACK.
       // AppDelegate.saveContext()
    
    }
}

extension AlarmController: AlarmScheduler {
   
}

/*
 Navigate back to your model controller and conform your AlarmController Class to the AlarmScheduler protocol. Notice how the compiler does not make you implement the schedule and cancel functions from the protocol? This is because by adding an extension to the protocol, we have created default implementation of these functions for all classes that conform to the protocol.
 Go through each of the CRUD functions and schedule / cancel the User Notifications based on the needs of that method.
 When an alarm is created it will need the alert scheduled.
 When an alarm is updated, cancel the first alert and then schedule the new one after the update is applied.
 When the alarm is enabled and disabled, handle the notifications accordingly
 When an alarm is deleted, we need to cancel the alert
 UNUserNotificationCenterDelegate
 The last thing you need to do is set up your app to notify the user when an alarm goes off and they still have the app open. In order to do this we are going to use the UNUserNotificationCenterDelegate protocol.
 */
