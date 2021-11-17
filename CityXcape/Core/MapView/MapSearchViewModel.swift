//
//  MapSearchViewModel.swift
//  CityXcape
//
//  Created by James Allan on 8/24/21.
//

import Foundation
import Combine
import SwiftUI
import MapKit


class MapSearchViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    
    @Published var annotations: [MKPointAnnotation] = [MKPointAnnotation]()
    @Published var isSearching: Bool = false
    @Published var searchQuery: String = ""
    @Published var mapItems: [MKMapItem] = [MKMapItem]()
    @Published var selectedMapItem: MKMapItem?
    @Published var keyboardHeight: CGFloat = 0
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var spotComplete: Bool = false
    
    private var region: MKCoordinateRegion?
    
    var cancellable: AnyCancellable?
    
    let locationManager = LocationService.instance.manager
    
    override init() {
        super.init()
        cancellable = $searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] (searchTerm) in
                self?.performSearch(query: searchTerm)
            }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorizationStatus()
        listenForKeyboardNotification()
    }
    
    fileprivate func listenForKeyboardNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else {return}
            guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
            let keyboardFrame = value.cgRectValue
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
            
            print("Keyboard changing value")
            withAnimation(.easeOut(duration: 0.3)) {
                self.keyboardHeight = keyboardFrame.height - (window!.safeAreaInsets.bottom + 20)
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else {return}
            
            print("Keyboard resigning value")
            withAnimation(.easeOut(duration: 0.5)) {
                self.keyboardHeight = 0
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: MapView.Coordinator.regionChangedNofication, object: nil, queue: .main) { [weak self] notification in
            
            self?.region = notification.object as? MKCoordinateRegion
        }
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "completeSpot"), object: nil, queue: .main) { [weak self] _ in
            
            self?.searchQuery = ""
            self?.spotComplete = true
        }
    }
        
   func performSearch(query: String) {
        
        isSearching = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        if let region = self.region {
            request.region = region
        }
        let localSearch = MKLocalSearch(request: request)
        
        localSearch.start { [weak self] response, error in
            
            self?.mapItems = response?.mapItems ?? []
            if let error = error {
                print("Failed to find locations", error)
            }
            var results: [MKPointAnnotation] = [MKPointAnnotation]()
            response?.mapItems.forEach({ mapItem in
               let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = mapItem.placemark.coordinate
                results.append(annotation)
            })
            
            Thread.sleep(forTimeInterval: 1)
            self?.isSearching = false
            self?.annotations = results
        }
    }
    
    fileprivate func checkAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            break
        case .denied:
            break
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        if status == .restricted || status == .denied || status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {return}
        self.currentLocation = firstLocation.coordinate
        
    }
}


class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let instance = LocationService()
    
    let manager = CLLocationManager()
    
    private override init() {}
}
