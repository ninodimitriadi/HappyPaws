//
//  ReminderViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/25/25.
//

import Foundation
import EventKit
import UserNotifications

class ReminderViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    @Published private(set) var reminders: [RemainderModel] = []

    init() {
        requestAccess { [weak self] granted in
            if granted {
                self?.fetchReminders()
            } else {
                print("Access to reminders was denied.")
            }
        }
        requestNotificationPermission()
    }

    // Request access to reminders
    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .reminder) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    // Request notification permissions
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
        }
    }

    // Fetch reminders from EventKit
    func fetchReminders() {
        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { [weak self] ekReminders in
            guard let self = self else { return }
            let fetchedReminders = ekReminders?.compactMap { ekReminder in
                RemainderModel(
                    id: ekReminder.calendarItemIdentifier,
                    title: ekReminder.title,
                    notes: ekReminder.notes,
                    dueDate: ekReminder.dueDateComponents?.date
                )
            } ?? []
            DispatchQueue.main.async {
                self.reminders = fetchedReminders
            }
        }
    }

    // Add a new reminder
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
            fetchReminders()
            
            // Schedule notification
            if let dueDate = dueDate {
                scheduleNotification(for: reminder, at: dueDate)
            }
            
            completion(true)
        } catch {
            print("Error saving reminder: \(error.localizedDescription)")
            completion(false)
        }
    }

    // Schedule local notification for a reminder
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

    // Delete a reminder
    func deleteReminder(withId id: String, completion: @escaping (Bool) -> Void) {
        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { [weak self] ekReminders in
            guard let self = self else { return }
            if let ekReminder = ekReminders?.first(where: { $0.calendarItemIdentifier == id }) {
                do {
                    try self.eventStore.remove(ekReminder, commit: true)
                    self.fetchReminders()

                    // Remove notification
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
                    
                    completion(true)
                } catch {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
}


