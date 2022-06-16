//
//  LocationService.swift
//  CityXcape
//
//  Created by James Allan on 6/15/22.
//

import Foundation
import CoreLocation
import SwiftUI


class LocationService: NSObject, CLLocationManagerDelegate {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    static let instance = LocationService()
    
    let manager = CLLocationManager()
    var userlocation: CLLocationCoordinate2D?
    var city: String?
    var country: String?
    var loadMessgae: String {
        return UserDefaults.standard.value(forKey: CurrentUserDefaults.loadMessgae)  as? String ?? "Loading Your City"
    }
   
    
    
    private override init() {
       super.init()
       manager.delegate = self
       checkAuthorizationStatus()
    }
    
    fileprivate func checkAuthorizationStatus() {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("Updating location")
            manager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation()
        case .restricted:
            break
        @unknown default:
            break
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userlocation = location.coordinate
            userlocation?.fetchCityAndCountry(completion: { [weak self] city, country, error in
                guard let self = self else {return}
                if let error = error {
                    print("Error finding location", error.localizedDescription)
                }
                self.city = city
                self.country = country
                self.saveUserLocation()
            })
            
        }
    }
    
    func saveUserLocation() {
        let oldCity = UserDefaults.standard.value(forKey: CurrentUserDefaults.city) as? String
        if let city = city {
            let message = "Loading \(city)"
            UserDefaults.standard.set(message, forKey: CurrentUserDefaults.loadMessgae)
            
                if city != oldCity ?? "" {
                    let data: [String: Any] = [
                        UserField.city: city
                    ]
                    guard let uid = userId else {return}
                    AuthService.instance.updateUserField(uid: uid, data: data)
                }
            
            UserDefaults.standard.set(city, forKey: CurrentUserDefaults.city)
        }
    }

    
}

