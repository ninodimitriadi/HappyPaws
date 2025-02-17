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

    public func bookAppointment(for doctorID: String, startTime: Date, completion: @escaping (Bool, String) -> Void) {
        let appointmentDuration: TimeInterval = 30 * 60
        let endTime = startTime.addingTimeInterval(appointmentDuration)

        db.collection("Doctor appointments")
            .whereField("doctorID", isEqualTo: doctorID)
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
                            if (startTime < existingEndTime && endTime > existingStartTime) {
                                completion(false, "This time slot is already booked.")
                                return
                            }
                        }
                    }
                }
                self.createAppointment(doctorID: doctorID, startTime: startTime, endTime: endTime, completion: completion)
            }
    }


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
