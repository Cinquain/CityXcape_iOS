//
//  LocationController.swift
//  CityXcape
//
//  Created by James Allan on 8/19/21.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI
import LBTATools


class LocationController: UIViewController {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()
        checkLocationServices()
        
    }
    
    fileprivate func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorizationStatus()
        }
    }
    
    fileprivate func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    fileprivate func checkAuthorizationStatus() {
        switch locationManager.authorizationStatus {
            case .authorizedAlways:
                break
            case .denied:
                print("Location denied")
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse:
                mapView.showsUserLocation = true
                locationManager.startUpdatingLocation()
            case .restricted:
                break
            @unknown default:
                break
        }
        
    }
    
    fileprivate func centerViewOnUserLocation() {
        guard let location = currentLocation else {return}
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
}


extension LocationController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    //Creates and customizes your annotion
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKPointAnnotation) {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
            annotationView.canShowCallout = true
            return annotationView
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            break
        case .denied:
            print("Location denied")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        currentLocation = location.coordinate
        guard let strongLocation = currentLocation else {return}
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: strongLocation, span: span)
        mapView.setRegion(region, animated: true)
    }
    
 

    
    
}


struct MapPreview: PreviewProvider {
    
    static var previews: some View {
        MapView()
            .edgesIgnoringSafeArea(.all)
            .colorScheme(.dark)
    }
}

struct MapView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> LocationController {
        return LocationController()
    }
    
    func updateUIViewController(_ uiViewController: LocationController, context: Context) {
        
    }
    
    typealias UIViewControllerType = LocationController
    
}


