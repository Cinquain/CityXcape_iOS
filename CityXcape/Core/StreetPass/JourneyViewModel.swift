//
//  JourneyViewModel.swift
//  CityXcape
//
//  Created by James Allan on 3/3/22.
//

import Firebase
import SwiftUI

class JourneyViewModel: NSObject, ObservableObject {
    
    
    @Published var verifications: [Verification] = []
    @Published var cities: [String: Int] = [:]
    @Published var showCollection: Bool = false
    @Published var showJournal: Bool = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var showShareSheet: Bool = false
    @Published var passportImage: UIImage?
    @Published var allowshare: Bool = false
    
    override init() {
        super.init()
        getVerificationForUser()
    }
    
    fileprivate func getCities() {
            
        verifications.forEach { verification in

            if let count = cities[verification.city] {
                cities[verification.city] = count + 1
            } else {
            
                cities[verification.city] = 1
            }
        }
        
    }
    
    fileprivate func getVerificationForUser() {
        DataService.instance.getVerifications { [weak self] verifications in
            self?.verifications = verifications
            self?.getCities()
        }
    }
    
    
    func openJournal() {
        AnalyticsService.instance.checkedJournal()
        if verifications.isEmpty {
            alertMessage = "You have no stamps in your journal. \n Go check in a location to get stamped."
            showAlert = true
        } else {
            showJournal = true
        }
    }
    
    func openCollection() {
        AnalyticsService.instance.checkedCityStamp()
        if cities.isEmpty {
            alertMessage = "You have no cities stamped in your journal. \n Go check into a location to get stamped."
            showAlert = true
        } else {
            showCollection = true
        }
    }
    
    func locationMessage() -> String {
        if verifications.count > 1 {
            return "\(verifications.count) Locations"
        } else {
            return "\(verifications.count) Location"
        }
    }
    
    func cityMessage() -> String {
        if cities.keys.count > 1 {
            return "\(cities.keys.count) Cities"
        } else {
            return "\(cities.keys.count) City"
        }
    }
    
    
    func shareStampImage(object: Verification) {
        let stampImage = generateStampImage(object: object)
        let activityVC = UIActivityViewController(activityItems: [stampImage], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.presentedViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func generateStampImage(object: Verification) -> UIImage {
        return StampImage(width: 500, height: 500, image: passportImage ?? UIImage(), title: object.name, date: object.time).snapshot()
    }

    
    
    
    func shareInstaStamp(object: Verification) {
        guard let instagramUrl = URL(string:"instagram-stories://share") else {return}
        let stampImage = StampImage(width: 720, height: 1080, image: passportImage ?? UIImage(), title: object.name, date: object.time).snapshot()
        
        if UIApplication.shared.canOpenURL(instagramUrl) {
            
            let pasteboardItem = [
                "com.instagram.sharedSticker.backgroundImage": stampImage
            ]
            
            
            let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]
            UIPasteboard.general.setItems([pasteboardItem], options: pasteboardOptions)
            UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
            
        } else {
            print("Cannot Find Instagram on Device")
        }
    }
    
    func getVerificationImage(object: Verification) {
        guard let url = URL(string: object.imageUrl) else {return}
        
         URLSession.shared.dataTask(with: url) { data, response, error in
            if let err = error {
                print("Error fetching image data", err.localizedDescription)
                return
            }
            print("Found image data!")
            guard let data = data else {return}
             DispatchQueue.main.async { [weak self] in
                 guard let self = self else {return}
                  let tempImage = UIImage(data: data)
                 self.passportImage = StampImage(width: 500, height: 600, image: tempImage ?? UIImage(), title: object.name, date: object.time).snapshot()
                 self.allowshare = true 
             }
            
        }
         .resume()
        
        
        
    }
 
    
    
    
    
    
}
