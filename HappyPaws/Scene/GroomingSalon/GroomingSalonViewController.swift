//
//  GroomingSalonViewController.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI

class GroomingSalonViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    private let mapView = MKMapView()
    private let viewModel = GroomingSalonViewModel()
    private let calloutView = CustomCalloutView()
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    private var selectedSalon: GroomingSalonModel?
    private var selectedSalonDetail: SalonDetailsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
        setupCalloutView()
        bindViewModel()
        fetchSalons()
    }

    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        mapView.delegate = self
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func bindViewModel() {
        viewModel.onSalonsUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.addSalonAnnotations()
            }
        }
    }

    private func fetchSalons() {
        guard let userLocation = userLocation else {
            return
        }
        viewModel.fetchNearbySalons(location: userLocation.coordinate, radius: 100000) 
    }
    private func addSalonAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        for salon in viewModel.salons {
            let annotation = CustomAnnotation(salonDetails: salon, coordinate: salon.coordinate)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func setupCalloutView() {
        calloutView.frame = CGRect(x: 20, y: view.frame.height - 250, width: view.frame.width - 40, height: 120)
        calloutView.isHidden = true
        calloutView.onTap = { [weak self] in
            self?.navigateSalonDetail()
        }

        view.addSubview(calloutView)
    }
    
    private func navigateSalonDetail() {
        guard let selectedSalon = selectedSalon, let selectedSalonDetail = selectedSalonDetail else {
            return
        }
        
        let groomingDetailView = NavigationView {
            GroomingDetailsUIView(salon: selectedSalon, salonDetail: selectedSalonDetail)
                .environmentObject(LanguageManager.shared)
        }

        let hostingController = UIHostingController(rootView: groomingDetailView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }



    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else { return nil }

        let identifier = "SalonAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "salonpin")
            annotationView?.frame.size = CGSize(width: 50, height: 50)
        } else {
            annotationView?.annotation = customAnnotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let customAnnotation = view.annotation as? CustomAnnotation else { return }

        let salonPlaceID = customAnnotation.salonDetails.placeID

        viewModel.fetchSalonDetails(placeID: salonPlaceID) { [weak self] salonDetails in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let salonDetails = salonDetails {
                    self.selectedSalon = customAnnotation.salonDetails
                    self.selectedSalonDetail = salonDetails

                    self.calloutView.configure(
                        name: customAnnotation.salonDetails.name,
                        rating: customAnnotation.salonDetails.rating,
                        distance: self.calculateDistance(to: customAnnotation.salonDetails),
                        clinicNumber: salonDetails.phoneNumber
                    )
                    self.calloutView.isHidden = false
                } else {
                    print("Failed to fetch salon details for placeID: \(salonPlaceID)")
                }
            }
        }
    }

    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        calloutView.isHidden = true
    }


    private func calculateDistance(to clinic: GroomingSalonModel) -> String {
        guard let userLocation = userLocation else { return "N/A" }
        let distance = userLocation.distance(from: CLLocation(latitude: clinic.coordinate.latitude, longitude: clinic.coordinate.longitude))
        return String(format:  "%.1f \(LanguageManager.shared.localizedString(forKey: "km"))", distance / 1000)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newUserLocation = locations.first else { return }
        
        userLocation = newUserLocation

        let region = MKCoordinateRegion(
            center: newUserLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        mapView.setRegion(region, animated: true)

        viewModel.fetchNearbySalons(location: newUserLocation.coordinate, radius: 2000)
        locationManager.stopUpdatingLocation()
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
}


