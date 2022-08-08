//
//  JourneyViewModel.swift
//  CityXcape
//
//  Created by James Allan on 3/3/22.
//

import Firebase
import SwiftUI

class JourneyViewModel: NSObject, ObservableObject, UIDocumentInteractionControllerDelegate {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?

    @Published var verification: Verification?
    @Published var verifications: [Verification] = []
    @Published var cities: [String: Int] = [:]
    @Published var showCollection: Bool = false
    @Published var showJournal: Bool = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var showShareSheet: Bool = false
    @Published var passportImage: UIImage?
    @Published var allowshare: Bool = false
    @Published var url: String?
    @Published var showJourney: Bool = false

    @Published var updateStampId: String = ""
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showPicker: Bool = false
    
    override init() {
        super.init()
        getVerificationsForUser()
    }
    
    fileprivate func getCities() {
        
        for verification in verifications {
            if verification.city == "" {continue}
            if let count = cities[verification.city] {
                cities[verification.city] = count + 1
            } else {
                cities[verification.city] = 1
            }
        }
        
    }
    
    fileprivate func getVerificationsForUser() {
        guard let uid = userId else {return}
        DataService.instance.getVerifications(uid: uid) { [weak self] verifications in
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
    
    func replaceStampImage(completion: @escaping (_ url: String) -> ()) {
        guard var wallet = wallet else {return}
        if wallet >= 1 {
            
            wallet -= 1
            UserDefaults.standard.set(wallet, forKey: CurrentUserDefaults.wallet)
            if let image = passportImage {
                DataService.instance.changeStampPhoto(postId: updateStampId, image: image) { [weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let imageUrl):
                        DispatchQueue.main.async {
                            self.url = imageUrl
                            self.alertMessage = "Successfully replaced image. -1 StreetCred"
                            self.showAlert = true
                            self.getVerificationsForUser()
                            completion(imageUrl)
                        }
                    case .failure(let error):
                        self.alertMessage = "Error upload image: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                }
            }
            
        } else {
            self.alertMessage = "You need 1 Streetcred to change stamp photo"
            self.showAlert = true
        }
    
    }
    
    func shareStampImage(object: Verification) {
        let stampImage = generateStampImage(object: object)
        let activityVC = UIActivityViewController(activityItems: [stampImage], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.presentedViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func generateStampImage(object: Verification) -> UIImage {
        return StampImage(image: passportImage ?? UIImage(), title: object.name, date: object.time, comment: object.comment).snapshot()
    }

    
    
    
    func shareInstaStamp(object: Verification) {
        guard let instagramUrl = URL(string:"instagram://share") else {return}
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: passportImage ?? UIImage())
        
        if UIApplication.shared.canOpenURL(instagramUrl) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
            }
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
                 self.passportImage = StampImage(image: tempImage ?? UIImage(), title: object.name, date: object.time, comment: object.comment).snapshot()
                 self.allowshare = true 
             }
            
        }
         .resume()
        
        
        
    }
    
    func getStampTitle() -> String {
        if verifications.count <= 1 {
            return "\(verifications.count) Stamp"
        } else {
            return "\(verifications.count) Stamps"
        }
        
    }
    
    
    func getVerificationForUser(userId: String) {
       AnalyticsService.instance.checkUserJourney()
       DataService.instance.getVerifications(uid: userId) { [weak self] verifications in
           guard let self = self else {return}
           if verifications.count == 0 {
               self.alertMessage = "This user has been nowhere"
               self.showAlert = true
           } else {
               self.verifications = verifications
               self.showJourney = true
           }
       }
   }
   
   func streetFollowerUser(fcm: String, user: User) {
       DataService.instance.streetFollowUser(user: user, fcmToken: fcm) { [weak self] succcess in
           guard let self = self else {return}
           if succcess {
               self.alertMessage = "Street Following \(user.displayName)"
               self.showAlert = true
           } else {
               self.alertMessage = "Cannot street follow \(user.displayName)"
               self.showAlert = true
           }
       }
   }
   
   func openInstagram(username: String) {
          //Open in brower
      let appURL = URL(string: "instagram://user?username=\(username)")!
      let application = UIApplication.shared
      
      if application.canOpenURL(appURL) {
          application.open(appURL, options: [:])
      } else {
          let webURL = URL(string: "https://instagram.com/\(username)")!
          application.open(webURL)
      }
      
  }
   
 
    
    
    
    
    
}
