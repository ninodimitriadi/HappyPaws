//
//  VetClinicViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/18/25.
//

import Firebase
import CoreLocation

class VetClinicViewModel {
    private let db = Firestore.firestore()
    private(set) var clinics: [ClinicModel] = []

    func fetchClinics(completion: @escaping ([ClinicModel]) -> Void) {
        db.collection("vetClinic").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching clinics: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No clinic data found")
                completion([])
                return
            }

            var fetchedClinics: [ClinicModel] = []

            for document in documents {
                let data = document.data()

                guard
                    let address = data["address"] as? String,
                    let coordinateData = data["coordinate"] as? GeoPoint,
                    let title = data["title"] as? String,
                    let clinicPhoneNumber = data["clinicPhoneNumber"] as? String,
                    let rating = data["rating"] as? Double,
                    let image = data["image"] as? String,
                    let doctorArray = data["doctor"] as? [[String: Any]]
                else {
                    print("Invalid data in document: \(document.documentID)")
                    continue
                }

                let coordinate = CLLocationCoordinate2D(latitude: coordinateData.latitude, longitude: coordinateData.longitude)

                var doctors: [DoctorModel] = []
                for doctorData in doctorArray {
                    guard
                        let name = doctorData["name"] as? String,
                        let status = doctorData["status"] as? String,
                        let experience = doctorData["experience"] as? Int,
                        let phoneNimber = doctorData["phoneNimber"] as? String,
                        let doctorImage = doctorData["image"] as? String,
                        let info = doctorData["info"] as? String,
                        let rating = doctorData["rating"] as? Double
                    else {
                        print("Invalid doctor data in clinic: \(title)")
                        continue
                    }

                    let doctor = DoctorModel(id: document.documentID, name: name, status: status, experience: experience, phoneNimber: phoneNimber, image: doctorImage, info: info, rating: rating)
                    doctors.append(doctor)
                }

                let clinic = ClinicModel(
                    address: address,
                    coordinate: coordinate,
                    title: title,
                    clinicPhoneNumber: clinicPhoneNumber,
                    rating: rating,
                    doctors: doctors,
                    image: image
                )

                fetchedClinics.append(clinic)
            }

            self.clinics = fetchedClinics
            DispatchQueue.main.async {
                completion(fetchedClinics)
            }
        }
    }

    func distanceFromUser(to clinic: ClinicModel, userLocation: CLLocation) -> String {
        let clinicLocation = CLLocation(latitude: clinic.coordinate.latitude, longitude: clinic.coordinate.longitude)
        let distanceInMeters = userLocation.distance(from: clinicLocation)
        let distanceInKilometers = distanceInMeters / 1000.0
        return String(format: "%.1f km away from you", distanceInKilometers)
    }
}
