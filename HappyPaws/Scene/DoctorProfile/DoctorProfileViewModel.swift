//
//  DoctorProfileViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/27/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class DoctorProfileViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var selectedDate: Date = Date()

    // Book an appointment for a doctor
    public func bookAppointment(for doctorID: String, startTime: Date, completion: @escaping (Bool, String) -> Void) {
        let appointmentDuration: TimeInterval = 30 * 60 // 30 minutes in seconds
        let endTime = startTime.addingTimeInterval(appointmentDuration)

        // Query Firestore to get all appointments for the doctor
        db.collection("Doctor appointments")
            .whereField("doctorID", isEqualTo: doctorID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(false, "Error fetching appointments: \(error.localizedDescription)")
                    return
                }

                // If there are no appointments or no conflict, proceed
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        let existingStartTime = (data["startTime"] as? Timestamp)?.dateValue()
                        let existingEndTime = (data["endTime"] as? Timestamp)?.dateValue()

                        // Check if the new appointment overlaps with any existing ones
                        if let existingStartTime = existingStartTime, let existingEndTime = existingEndTime {
                            if (startTime < existingEndTime && endTime > existingStartTime) {
                                // There's an overlap with an existing appointment
                                completion(false, "This time slot is already booked.")
                                return
                            }
                        }
                    }
                }

                // If no overlap found, create the appointment
                self.createAppointment(doctorID: doctorID, startTime: startTime, endTime: endTime, completion: completion)
            }
    }


    // Create a new appointment in Firestore
    private func createAppointment(doctorID: String, startTime: Date, endTime: Date, completion: @escaping (Bool, String) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false, "User is not logged in.")
            return
        }

        let appointmentData: [String: Any] = [
            "doctorID": doctorID,
            "userID": userID,
            "startTime": startTime,
            "endTime": endTime,
            "status": "booked"
        ]

        db.collection("Doctor appointments").addDocument(data: appointmentData) { error in
            if let error = error {
                completion(false, "Error booking appointment: \(error.localizedDescription)")
            } else {
                completion(true, "Appointment successfully booked!")
            }
        }
    }
}
