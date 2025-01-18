//
//  VetClinicViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/18/25.
//

import CoreLocation

class VetClinicViewModel {
    private(set) var clinics: [ClinicModel] = []

    func fetchClinics(completion: @escaping ([ClinicModel]) -> Void) {
        // Doctor data for clinics
        let doctor1 = DoctorModel(name: "Dr. George Smith", status: "Available", experience: 10, phoneNimber: "+995 555 123 456", image: "doctor1.jpg")
        let doctor2 = DoctorModel(name: "Dr. Anna Johnson", status: "On Leave", experience: 5, phoneNimber: "+995 555 654 321", image: "doctor2.jpg")
        let doctor3 = DoctorModel(name: "Dr. Michael Brown", status: "Available", experience: 8, phoneNimber: "+995 555 987 654", image: "doctor3.jpg")
        let doctor4 = DoctorModel(name: "Dr. Laura Williams", status: "Available", experience: 12, phoneNimber: "+995 555 246 810", image: "doctor4.jpg")

        // Clinic data for Tbilisi
        let clinic1 = ClinicModel(
            address: "5 Freedom Square, Tbilisi, Georgia",
            coordinate: CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271),
            title: "Tbilisi Vet Clinic",
            clinicPhoneNumber: "+995 599 123 456",
            rating: 4.5,
            doctors: [doctor1, doctor2],
            image: "clinic1.jpg"
        )

        let clinic2 = ClinicModel(
            address: "3 Rustaveli Ave, Tbilisi, Georgia",
            coordinate: CLLocationCoordinate2D(latitude: 41.7244, longitude: 44.7923),
            title: "Friendly Vet Center",
            clinicPhoneNumber: "+995 599 654 321",
            rating: 4.7,
            doctors: [doctor3, doctor4],
            image: "clinic2.jpg"
        )

        let clinic3 = ClinicModel(
            address: "7 Abashidze St, Tbilisi, Georgia",
            coordinate: CLLocationCoordinate2D(latitude: 41.7225, longitude: 44.7812),
            title: "Happy Paws Veterinary",
            clinicPhoneNumber: "+995 599 789 123",
            rating: 3.9,
            doctors: [doctor1, doctor3],
            image: "clinic3.jpg"
        )

        let clinic4 = ClinicModel(
            address: "9 Chavchavadze Ave, Tbilisi, Georgia",
            coordinate: CLLocationCoordinate2D(latitude: 41.7237, longitude: 44.7985),
            title: "Pets Care Clinic",
            clinicPhoneNumber: "+995 599 321 789",
            rating: 4.2,
            doctors: [doctor2, doctor4],
            image: "clinic4.jpg"
        )

        let fetchedClinics = [clinic1, clinic2, clinic3, clinic4]
        
        self.clinics = fetchedClinics
        
        DispatchQueue.main.async {
            completion(fetchedClinics)
        }
    }


    func distanceFromUser(to clinic: ClinicModel, userLocation: CLLocation) -> String {
        let clinicLocation = CLLocation(latitude: clinic.coordinate.latitude, longitude: clinic.coordinate.longitude)
        let distanceInMeters = userLocation.distance(from: clinicLocation)
        let distanceInKilometers = distanceInMeters / 1000.0
        return String(format: "%.1f km away from you", distanceInKilometers)
    }
}
