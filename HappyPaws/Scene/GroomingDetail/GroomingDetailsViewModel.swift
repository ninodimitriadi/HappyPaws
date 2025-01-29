//
//  GroomingDetailsViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/29/25.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class GroomingDetailsViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var selectedDate: Date = Date()

    public func bookGroomingAppointment(for salonID: String, startTime: Date, completion: @escaping (Bool, String) -> Void) {
        let appointmentDuration: TimeInterval = 60 * 60 // 1 hour duration
        let endTime = startTime.addingTimeInterval(appointmentDuration)

        db.collection("Grooming appointments")
            .whereField("salonID", isEqualTo: salonID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(false, "Error fetching appointments: \(error.localizedDescription)")
                    return
                }

                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        let existingStartTime = (data["startTime"] as? Timestamp)?.dateValue()
                        let existingEndTime = (data["endTime"] as? Timestamp)?.dateValue()

                        if let existingStartTime = existingStartTime, let existingEndTime = existingEndTime {
                            // Check if the new appointment overlaps with the existing one
                            if (startTime < existingEndTime && endTime > existingStartTime) {
                                completion(false, "This time slot is already booked.")
                                return
                            }
                        }
                    }
                }
                self.createGroomingAppointment(salonID: salonID, startTime: startTime, endTime: endTime, completion: completion)
            }
    }

    private func createGroomingAppointment(salonID: String, startTime: Date, endTime: Date, completion: @escaping (Bool, String) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false, "User is not logged in.")
            return
        }

        let appointmentData: [String: Any] = [
            "salonID": salonID,
            "userID": userID,
            "startTime": Timestamp(date: startTime),
            "endTime": Timestamp(date: endTime),
            "status": "booked"
        ]

        db.collection("Grooming appointments").addDocument(data: appointmentData) { error in
            if let error = error {
                completion(false, "Error booking appointment: \(error.localizedDescription)")
            } else {
                completion(true, "Appointment successfully booked!")
            }
        }
    }
}
