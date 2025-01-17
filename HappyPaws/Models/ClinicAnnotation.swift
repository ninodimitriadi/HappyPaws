//
//  ClinicAnnotation.swift
//  HappyPaws
//
//  Created by nino on 1/17/25.
//


import Foundation
import MapKit

class ClinicAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var clinicPhoneNumber: String
    var rating: Double
    
    
    init(coordinate: CLLocationCoordinate2D, title: String, clinicPhoneNumber: String, rating: Double) {
        self.coordinate = coordinate
        self.title = title
        self.clinicPhoneNumber = clinicPhoneNumber
        self.rating = rating
    }
}
