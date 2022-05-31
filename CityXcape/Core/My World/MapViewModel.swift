//
//  MapViewModel.swift
//  CityXcape
//
//  Created by James Allan on 2/23/22.
//

import Foundation
import MapKit
import SwiftUI
import Combine


class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool  = false
    @Published var showCheckin: Bool = false

    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var route: MKRoute?
    @Published var routeText: String = "Press checkin when you arrive"
    @Published var missionText: String = "Go to the location to get your stamp, \n press route when you're ready to go"
    
    let locationManager = LocationService.instance.manager
    let coreData = CoreDataManager.instance
    
    
    override init() {
        super.init()
        checkAuthorizationStatus()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    fileprivate func checkAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            locationManager.requestWhenInUseAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {return}
        self.currentLocation = firstLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
        
        if status == .restricted || status == .denied || status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func calculateRoute(spot: SecretSpot) {
        let request = MKDirections.Request()
        guard let userlocal = currentLocation else { print("Can't Find User Location"); return }
        let startpoint = CLLocationCoordinate2D(latitude:  userlocal.latitude, longitude: userlocal.longitude)
        let destination = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        let mapItemA = MKMapItem(placemark: .init(coordinate: startpoint, addressDictionary: nil))
        let mapItemB = MKMapItem(placemark: .init(coordinate: destination, addressDictionary: nil))
        request.source = mapItemA
        request.destination = mapItemB
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] (response, error) in
            
            if let error = error {
                print("Failed to calculate directions", error.localizedDescription)
                return
            }
            
            self?.route = response?.routes.first
        
        }
        
        
    }
    
    func updateRoute(spot: SecretSpot) {
       routeText = "\(String(format: "%.1f", spot.distanceFromUser)) miles away."
    }
    
    func checkIfVerifiable(spot: SecretSpot) {
        AnalyticsService.instance.touchedVerification()
        let manager = LocationService.instance.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            let manager = LocationService.instance.manager
            let spotLocation = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
            let userLocation = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
            let distance = userLocation.distance(from: spotLocation)
            let distanceInFeet = distance * 3.28084
            let distanceInMiles = distance * 0.000621371
            let formattedDistance = String(format: "%.1f", distanceInMiles)
            print("\(distance) feet")
            if distanceInFeet < 200 {
                showCheckin = true 
            } else {
                //Distance is greater than 200 feet
                showAlert = true
                alertMessage = "You need to be there to checkin. \n You are \(formattedDistance) mile away"
            }
                
    } else {
        manager.requestWhenInUseAuthorization()
    }
}
    

    
    
  
    
    
    
    
    
}
