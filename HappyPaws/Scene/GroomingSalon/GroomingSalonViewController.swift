//
//  GroomingSalonViewController.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import UIKit
import MapKit
import CoreLocation

class GroomingSalonViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    private let mapView = MKMapView()
    private let viewModel = GroomingSalonViewModel()
    private let calloutView = CustomCalloutView()
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
        setupCalloutView()
        bindViewModel()
        fetchSalons()
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        print("MapView added successfully") // Debugging line
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("Location Manager Started") // Debugging line
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
            print("User location is not available yet.")
            return
        }
        viewModel.fetchNearbySalons(location: userLocation.coordinate, radius: 100000) 
    }
    private func addSalonAnnotations() {
        print("Adding salon annotations...")
        mapView.removeAnnotations(mapView.annotations)
        
        for salon in viewModel.salons {
            print("Adding annotation for salon: \(salon.name), coordinates: \(salon.coordinate.latitude), \(salon.coordinate.longitude), \(salon.phoneNumber)")
            let annotation = CustomAnnotation(salonDetails: salon, coordinate: salon.coordinate)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func setupCalloutView() {
        calloutView.frame = CGRect(x: 20, y: view.frame.height - 250, width: view.frame.width - 40, height: 120)
        calloutView.isHidden = true

        view.addSubview(calloutView)
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

                if let salonDetails = salonDetails {
                    self.calloutView.configure(
                        name: customAnnotation.salonDetails.name,
                        rating: customAnnotation.salonDetails.rating,
                        distance: self.calculateDistance(to: customAnnotation.salonDetails),
                        clinicNumber: salonDetails.phoneNumber
                    )
                    DispatchQueue.main.async { [weak self] in
                        self?.calloutView.isHidden = false
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
        return String(format: "%.1f km", distance / 1000)
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


