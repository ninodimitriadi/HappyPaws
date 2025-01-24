//
//  GroomingSalonViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/22/25.
//

import Foundation
import CoreLocation

class GroomingSalonViewModel {
    private let networkService = NetworkService()
    private(set) var salons: [GroomingSalonModel] = []
    var onSalonsUpdated: (() -> Void)?

    func fetchNearbySalons(location: CLLocationCoordinate2D, radius: Int) {
        let locationString = "\(location.latitude),\(location.longitude)"
        print("Fetching salons for location: \(locationString)") // Debugging line
        
        networkService.fetchNearbySalons(location: locationString, radius: radius) { [weak self] salons in
            guard let self = self else { return }
            if let salons = salons {
                print("Fetched salons: \(salons)") // Debugging line
                self.salons = salons
                self.onSalonsUpdated?()
            } else {
                print("No salons found.") // Debugging line
            }
        }
    }

    func fetchSalonDetails(placeID: String, completion: @escaping (SalonDetailsModel?) -> Void) {
        networkService.fetchSalonDetails(placeID: placeID, completion: completion)
    }
    
    func distanceFromUser(to clinic: ClinicModel, userLocation: CLLocation) -> String {
        let clinicLocation = CLLocation(latitude: clinic.coordinate.latitude, longitude: clinic.coordinate.longitude)
        let distanceInMeters = userLocation.distance(from: clinicLocation)
        let distanceInKilometers = distanceInMeters / 1000.0
        return String(format: "%.1f km away from you", distanceInKilometers)
    }
}
