//
//  AlarmController.swift
//  AlarmCoreData
//
//  Created by Lee McCormick on 1/21/21.
//

import CoreData

class AlarmController: AlarmScheduler  {
    
    // MARK: - Properties
    static let shared = AlarmController()
    var alarms: [Alarm] = []
    private lazy var fetchRequest : NSFetchRequest<Alarm> = {
        let request = NSFetchRequest<Alarm>(entityName: "Alarm")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - CRUD Methods
    // CREATE
    func createAlarm(withTitle title: String, fireDate: Date) {
        let newAlarm = Alarm(title: title, isEnabled: false, fireDate: fireDate)
        alarms.append(newAlarm)
        CoreDataStack.saveContext()
        scheduleUserNotifications(for: newAlarm)
    }
    
    // READ
    func fetchAlarms() {
        self.alarms = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    // UPDATE
    func update(alarm: Alarm, newTitle: String, newFireDate: Date, isEnabled: Bool) {
        cancelUserNotifications(for: alarm)
        alarm.title = newTitle
        alarm.fireDate = newFireDate
        alarm.isEnabled = isEnabled
        CoreDataStack.saveContext()
        scheduleUserNotifications(for: alarm)
    }
    
    func toggleIsEnabledFor(alarm: Alarm) {
        alarm.isEnabled.toggle()
        CoreDataStack.saveContext()
        if alarm.isEnabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
    }
    
    // DELETE
    func delete(alarm: Alarm) {
        CoreDataStack.context.delete(alarm)
        CoreDataStack.saveContext()
        fetchAlarms()
        cancelUserNotifications(for: alarm)
    }
}

