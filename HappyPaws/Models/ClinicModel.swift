//
//  ClinicAnnotation.swift
//  HappyPaws
//
//  Created by nino on 1/17/25.
//


import Foundation
import MapKit

class ClinicModel: NSObject, MKAnnotation {
    var address: String
    var coordinate: CLLocationCoordinate2D
    let title: String?
    var clinicPhoneNumber: String
    var rating: Double
    var doctors: [DoctorModel]
    let image: String
    
    init(address: String, coordinate: CLLocationCoordinate2D, title: String?, clinicPhoneNumber: String, rating: Double, doctors: [DoctorModel], image: String) {
        self.address = address
        self.coordinate = coordinate
        self.title = title
        self.clinicPhoneNumber = clinicPhoneNumber
        self.rating = rating
        self.doctors = doctors
        self.image = image
    }
}
