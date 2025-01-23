//
//  GroomingSalonModel.swift
//  HappyPaws
//
//  Created by nino on 1/22/25.
//

import Foundation
import CoreLocation
import MapKit

struct GroomingSalonModel {
    var placeID: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let phoneNumber: String
    let rating: Double
}

struct SalonDetailsModel: Decodable {
    let address: String
    let phoneNumber: String
    let website: String?
    let openingHours: [String]?
}
