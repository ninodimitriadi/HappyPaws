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
        let appointmentDuration: TimeInterval = 60 * 60
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
    
    func formatOpeningHours(_ openingHours: [String]) -> [String] {
        let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        let weekends = ["Saturday", "Sunday"]
        
        var weekdayHoursSet: Set<String> = []
        var weekendHoursSet: Set<String> = []
        
        for hours in openingHours {
            let components = hours.components(separatedBy: ": ")
            guard components.count == 2 else { continue }
            
            let day = components[0].trimmingCharacters(in: .whitespaces)
            let time = components[1].trimmingCharacters(in: .whitespaces)
            
            if weekdays.contains(day) {
                weekdayHoursSet.insert(time)
            } else if weekends.contains(day) {
                weekendHoursSet.insert(time)
            }
        }
        
        let workdayHours = weekdayHoursSet.count == 1 ? "Workdays: \(weekdayHoursSet.first!)" : "Workdays: Varies"
        let weekendHours = weekendHoursSet.count == 1 ? "Weekend: \(weekendHoursSet.first!)" : "Weekend: Varies"
        
        return [workdayHours, weekendHours]
    }
}
