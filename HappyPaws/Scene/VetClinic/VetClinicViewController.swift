//
//  VetClinicViewController.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import UIKit
import MapKit
import CoreLocation

class VetClinicViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private let calloutView = CustomCalloutView()
    private var userLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        calloutView.frame = CGRect(x: 20, y: view.frame.height - 250, width: view.frame.width - 40, height: 120)
        calloutView.isHidden = true
        view.addSubview(calloutView)
        
        addClinicPins()
    }
    
    // MARK: - Add Clinic Pins
    private func addClinicPins() {
        let clinic1 = ClinicAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271),
            title: "Tbilisi Vet Clinic",
            clinicPhoneNumber: "+995 599 123 456",
            rating: 4.0
        )
        
        let clinic2 = ClinicAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 41.7205, longitude: 44.7952),
            title: "Friendly Vet Center",
            clinicPhoneNumber: "+995 599 654 321",
            rating: 4.6
        )
        
        let clinic3 = ClinicAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 41.7106, longitude: 44.8067),
            title: "Happy Paws Vet",
            clinicPhoneNumber: "+995 599 789 123",
            rating: 3.2
        )
        
        mapView.addAnnotations([clinic1, clinic2, clinic3])
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLocation = location
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 15000,
            longitudinalMeters: 15000
        )
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "ClinicPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "hospitalPin")
        annotationView?.frame.size = CGSize(width: 50, height: 50) 
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let userLocation = userLocation else { return }
        
        let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let distanceInMeters = userLocation.distance(from: annotationLocation)
        let distanceInKilometers = distanceInMeters / 1000.0
        
        if let clinicAnnotation = annotation as? ClinicAnnotation {
            calloutView.configure(
                name: clinicAnnotation.title ?? "Clinic",
                distance: String(format: "%.1f km away from you", distanceInKilometers),
                clinicNumber: clinicAnnotation.clinicPhoneNumber,
                rating: String(clinicAnnotation.rating)
            )
        }
        
        calloutView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        calloutView.isHidden = true
    }
}



