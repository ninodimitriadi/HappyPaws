//
//  VetClinicViewController.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI

class VetClinicViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private let viewModel = VetClinicViewModel()
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private let calloutView = CustomCalloutView()
    private var userLocation: CLLocation?
    private var selectedClinic: ClinicModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
        setupCalloutView()
        addClinicPins()
    }

    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapView.delegate = self
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func setupCalloutView() {
        calloutView.frame = CGRect(x: 20, y: view.frame.height - 250, width: view.frame.width - 40, height: 120)
        calloutView.isHidden = true
        calloutView.onTap = { [weak self] in
            self?.navigateToClinicDetail()
        }
        view.addSubview(calloutView)
    }

    private func navigateToClinicDetail() {
        guard let selectedClinic = selectedClinic else { return }
        let clinicDetailView = VetClinicDetailUIView(clinic: selectedClinic)
            .environmentObject(LanguageManager.shared)
        let hostingController = UIHostingController(rootView: clinicDetailView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true, completion: nil)
    }

    private func addClinicPins() {
        viewModel.fetchClinics { [weak self] clinics in
            print("Fetched clinics: \(clinics.count)")
            DispatchQueue.main.async {
                self?.mapView.addAnnotations(clinics)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLocation = location
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 30000,
            longitudinalMeters: 30000
        )
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        guard annotation is ClinicModel else { return nil }

        let identifier = "ClinicPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "hospitalPin")
            annotationView?.frame.size = CGSize(width: 50, height: 50)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }


    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let clinicModel = annotation as? ClinicModel else { return }

        selectedClinic = clinicModel
        
        calloutView.configure(
            name: clinicModel.title ?? "N/A",
            rating: clinicModel.rating,
            distance: calculateDistance(to: clinicModel),
            clinicNumber: clinicModel.clinicPhoneNumber
        )
        
        calloutView.isHidden = false
    }

    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        calloutView.isHidden = true
    }

    private func calculateDistance(to clinic: ClinicModel) -> String {
        guard let userLocation = userLocation else { return "N/A" }
        let distance = userLocation.distance(from: CLLocation(latitude: clinic.coordinate.latitude, longitude: clinic.coordinate.longitude))
        return String(format:  "%.1f \(LanguageManager.shared.localizedString(forKey: "km"))", distance / 1000)
    }
}


