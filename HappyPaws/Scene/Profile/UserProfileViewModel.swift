//
//  UserProfileViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/20/25.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import EventKit
import UserNotifications
import Combine

class UserProfileViewModel: ObservableObject {
    @Published var reminders: [EKReminder] = []
    @Published var user: UserModel?
    
    var onImageUploaded: ((URL?) -> Void)?
    var onError: ((Error) -> Void)?
    var onLogoutSuccess: (() -> Void)?
    var onRemindersUpdated: (() -> Void)?
    
    private let eventStore = EKEventStore()
    
    init() {
        requestAccess { [weak self] granted in
            if granted {
                self?.fetchReminders()
            } else {
                print("Access to reminders was denied.")
            }
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let fileName = "\(Auth.auth().currentUser?.uid ?? "unknown_user")_profile.jpg"
        let storageRef = Storage.storage().reference().child("profile_images").child(fileName)
        
        storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            if let error = error {
                print("Failed to upload image: \(error.localizedDescription)")
                self?.onImageUploaded?(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve download URL: \(error.localizedDescription)")
                    self?.onImageUploaded?(nil)
                    return
                }
                
                if let url = url {
                    self?.updateUserProfileImageURL(url)
                }
            }
        }
    }

    private func updateUserProfileImageURL(_ url: URL) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let userDocRef = Firestore.firestore().collection("users").document(userID)
        
        userDocRef.setData(["profileImage": url.absoluteString], merge: true) { [weak self] error in
            if let error = error {
                print("Failed to update Firestore: \(error.localizedDescription)")
                self?.onError?(error)
            } else {
                self?.onImageUploaded?(url)
            }
        }
    }
    
    func fetchCurrentUser(completion: @escaping (UserModel?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(currentUser.uid).getDocument { document, error in
            if let error = error {
                print("there is an error while fetching user: \(error.localizedDescription)")
                completion(nil)
            } else {
                guard let document = document, document.exists else {
                    completion(nil)
                    return
                }
                
                let userName = document.get("username") as? String ?? "Unknown"
                let email = document.get("email") as? String ?? "No email"
                let profileImageURLString = document.get("profileImage") as? String
                let profileImageURL = profileImageURLString.flatMap { URL(string: $0) }
                
                let user = UserModel(uID: currentUser.uid, userName: userName, email: email, profileImage: profileImageURL)
                self.user = user
                completion(user)
            }
        }
    }

    func logoutUser() {
        do {
            try Auth.auth().signOut()
            onLogoutSuccess?()
        } catch {
            onError?(error)
        }
    }
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .reminder) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
        }
    }

    func fetchReminders() {
        let predicate = eventStore.predicateForReminders(in: nil)
        
        eventStore.fetchReminders(matching: predicate) { [weak self] (reminders: [EKReminder]?) in
            if let reminders = reminders {
                DispatchQueue.main.async {
                    self?.reminders = reminders
                    self?.onRemindersUpdated?()
                }
            }
        }
    }

    private func scheduleNotification(for reminder: EKReminder, at dueDate: Date) {
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

    private func deleteReminderFromEventKit(withId id: String, completion: @escaping (Bool) -> Void) {
        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { [weak self] ekReminders in
            guard let self = self else { return }
            if let ekReminder = ekReminders?.first(where: { $0.calendarItemIdentifier == id }) {
                do {
                    try self.eventStore.remove(ekReminder, commit: true)
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

    func deleteReminder(at index: Int) {
        let reminderToDelete = reminders[index]
        
        deleteReminderFromEventKit(withId: reminderToDelete.calendarItemIdentifier) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.reminders.remove(at: index)
                    self?.onRemindersUpdated?()
                }
            } else {
                self?.onError?(NSError(domain: "UserProfileViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to delete reminder"]))
            }
        }
    }
}



