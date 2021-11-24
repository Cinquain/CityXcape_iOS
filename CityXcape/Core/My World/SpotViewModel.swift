//
//  SpotViewModel.swift
//  CityXcape
//
//  Created by James Allan on 11/22/21.
//

import SwiftUI
import CoreLocation




class SpotViewModel: NSObject, ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    
    @Published var alertmessage: String = ""
    @Published var alertTitle: String = ""
    @Published var genericAlert: Bool = false
    
    @Published var checkinMessage: String = ""
    @Published var checkinAlert: Bool = false
    @Published var showCheckin: Bool = false
    @Published var disableCheckin: Bool = false
    
    func openGoogleMap(spot: SecretSpot) {
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
            
        } else {
            //Open in brower
            if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url)
            }
            
        }

    }
    
    func checkInSecretSpot(spot: SecretSpot) {
        disableCheckin = true
        AnalyticsService.instance.checkedIn()
        
        let manager = LocationService.instance.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedWhenInUse {
            let manager = LocationService.instance.manager
            let spotLocation = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
            let userLocation = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
            let distance = userLocation.distance(from: spotLocation) * 3.28084
            print("\(distance) feet")
            if distance < 50 {
                showCheckin = true
                DataService.instance.checkinSecretSpot(spot: spot) { [weak self] success  in
                    
                    if !success {
                        print("Error saving checkin to database")
                        self?.checkinMessage = "Error saving check-in to database"
                        self?.checkinAlert = true
                        self?.disableCheckin = false
                        return
                    }
                    
                    print("Successfully saved checkin to database")
                    self?.showCheckin = true
                    
                }
            } else {
                checkinMessage = "You need to be there to check-in. \n You are \(distance) feet away."
                checkinAlert = true
                disableCheckin = false
            }
        } else {
            manager.requestWhenInUseAuthorization()
            disableCheckin = false
        }
        
        
    }
    
    
    
    func reportPost(reason: String, spot: SecretSpot) {
          print("Reporting post")
          AnalyticsService.instance.reportPost()
          DataService.instance.uploadReports(reason: reason, postId: spot.postId) { success in
              
              if success {
                  self.alertTitle = "Successfully Reported"
                  self.alertmessage = "Thank you for reporting this spot. We will review it shortly!"
                  self.genericAlert.toggle()
              } else {
                  self.alertTitle = "Error Reporting Spot"
                  self.alertmessage = "There was an error reporting this secret spot. Please restart the app and try again."
                  self.genericAlert.toggle()
              }
          }

      }
    
    
    func deletePost(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
        
        DataService.instance.deleteSecretSpot(spot: spot) { success in
           
           if success {
               self.alertTitle = "Successfully Deleted"
               self.alertmessage = "This secret spot has been removed from your world"
               self.genericAlert.toggle()
               AnalyticsService.instance.deletePost()
               completion(success)
           } else {
               self.alertTitle = "Error"
               self.alertmessage = "There was an error in deleting this spot. Restart the app and try again"
               self.genericAlert.toggle()
               completion(success)
           }
       }
   }
    
}
