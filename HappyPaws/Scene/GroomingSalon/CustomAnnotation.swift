//
//  CustomAnnotation.swift
//  HappyPaws
//
//  Created by nino on 1/22/25.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var salonDetails: GroomingSalonModel

    init(salonDetails: GroomingSalonModel, coordinate: CLLocationCoordinate2D) {
        self.salonDetails = salonDetails
        self.coordinate = coordinate
    }

    var title: String? {
        return salonDetails.name
    }
}
