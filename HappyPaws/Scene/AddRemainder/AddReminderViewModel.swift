//
//  AddReminderViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/25/25.
//

import Foundation
import EventKit
import UserNotifications

class AddReminderViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    var userProfileViewModel: UserProfileViewModel?
    
    @Published var reminders: [RemainderModel] = []
    var onReminderAdded: (() -> Void)?
    
    func addReminder(title: String, notes: String?, dueDate: Date?, completion: @escaping (Bool) -> Void) {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        reminder.notes = notes
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        
        if let dueDate = dueDate {
            reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        }
        
        do {
            try eventStore.save(reminder, commit: true)
            onReminderAdded?()
            
            if let dueDate = dueDate {
                scheduleNotification(for: reminder, at: dueDate)
            }
            
            completion(true)
        } catch {
            print("Error saving reminder: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func scheduleNotification(for reminder: EKReminder, at dueDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = reminder.title ?? "Reminder"
        content.body = reminder.notes ?? "You have a reminder due!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: reminder.calendarItemIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}







