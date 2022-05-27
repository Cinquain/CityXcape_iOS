//
//  PostViewModel.swift
//  CityXcape
//
//  Created by James Allan on 12/3/21.
//

import SwiftUI
import MapKit
import FirebaseMessaging


class PostViewModel: NSObject, ObservableObject {
    
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    
    
    var worldPlaceHolder = "i.e: #Artists #Skaters #Urbex"
    var privatePlaceHolder = "Secret Spot is Private"
    var worldDefinition = "Different World Different Spots"
    var detailsPlaceHolder = "  Describe why this spot is special"
    var pricePlaceHolder = " 1"
    var price: Int = 1
    let manager = CoreDataManager.instance
    let analytics = AnalyticsService.instance
    
    @Published var spotName: String = ""
    @Published var details: String = ""
    @Published var world: String = ""
    @Published var isPublic: Bool = true
    @Published var refresh: Bool = false
    @Published var priceString: String = ""
    @Published var isLoading: Bool = false

    
    @Published var showPicker: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var selectedImage: UIImage?

    
    @Published var presentPopover: Bool = false
    @Published var showActionSheet: Bool = false
    @Published var buttonDisabled: Bool = false
    @Published var showLeaderboard: Bool = false
    @Published var showRanks: Bool = false
    
    
    @Published var presentCompletion: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var showSuggestions: Bool = false
    @Published var worldSuggestions: [String] = ["#Urbex", "#Skater", "#History", "#Art", "#Scout"]
    
    @Published var rankings: [Rank] = []
    @Published var rank: String = ""
    @Published var progressString: String = ""
    @Published var progressValue: CGFloat = 0
    
    
    func isReady(mapItem: MKMapItem)  {
        price = Int(priceString) ?? 1
        
        if isPublic == false {
            world = "Private"
        }
        
        if spotName.count > 4
            && selectedImage != nil
            && details.count > 10
            && world.count >= 2
              {
            
            self.postSecretSpot(mapItem: mapItem)
            
        } else {
            
            if spotName.count < 4 {
                alertMessage = "Spot needs a title at least four characters long"
                showAlert.toggle()
                return
            }
            
            if details.count < 10 {
                alertMessage = "Description needs to be at least 10 characters long"
                showAlert.toggle()
                return
            }
            
            if world.count < 3 {
                alertMessage = "Please include a World. \n Your world should be at least 3 characters long"
                showAlert.toggle()
                return
            }
            
            if selectedImage == nil {
                alertMessage = "Please add an image for your spot"
                showAlert.toggle()
                return
            }
            
           
            
        }
    }
    
    func postSecretSpot(mapItem: MKMapItem) {
        isLoading = true
        buttonDisabled = true
        guard let image = selectedImage else {return}
        
        DataService.instance.uploadSecretSpot(spotName: spotName, description: details, image: image, price: price, world: world, mapItem: mapItem, isPublic: isPublic) { [weak self] (success) in
            guard let self = self else {return}
            if success {
                self.isLoading = false
                self.buttonDisabled = false
                self.getScoutLeaders()
                self.calculateRank()
                self.presentCompletion.toggle()
            } else {
                self.isLoading = false
                self.buttonDisabled = false
                self.showAlert.toggle()
                self.alertMessage = "Error posting Secret Spot 😤"
            }
        }
    }
    
    
    func converToHashTag() {
        
        var newWords = [String]()
        let wordsArray = world.components(separatedBy:" ")
            
        
        for word in wordsArray {
            if word.count > 0 {
                
                if word.contains("#") {
                    let newWord = word.replacingOccurrences(of: "#", with: "")
                                    
                    newWords.append("#\(newWord.capitalizingFirstLetter())")
                } else {
                    let newWord = "#\(word.capitalizingFirstLetter())"
                    newWords.append(newWord)
                }
            }
            
         
        }
        world = ""
//        newWords.forEach({ world += " \($0)"})
        var count = 1
        for word in newWords {
            if count == 4 {
                break
            }
            world += " \(word)"
            count += 1
            
        }
    }
    
    func getScoutLeaders() {
       DataService.instance.getUserRankings { ranks in
           self.rankings = ranks
       }
   }
   
   func calculateRank() {
       
       let allspots = manager.spotEntities.map({SecretSpot(entity: $0)})
       let verifiedSpots = allspots.filter({$0.verified == true})
       let totalStamps = verifiedSpots.count
       let ownerSpots = allspots.filter({$0.ownerId == userId})
       let totalSpotsPosted = ownerSpots.count
       let totalSaves = ownerSpots.reduce(0, {$0 + $1.saveCounts})
       let totalVerifications = ownerSpots.reduce(0, {$0 + $1.verifierCount})
       var totalCities: Int = 0
       var cities: [String: Int] = [:]
       verifiedSpots.forEach { spot in
           if let count = cities[spot.city] {
               cities[spot.city] = count + 1
           } else {
               cities[spot.city] = 1
               totalCities += 1
           }
       }
       
       (self.rank,
        self.progressString,
        self.progressValue) = Rank.calculateRank(totalSpotsPosted: totalSpotsPosted, totalSaves: totalSaves, totalStamps: totalStamps)

       guard let uid = userId else {return}
       guard let imageUrl = profileUrl else {return}
       guard let username = displayName else {return}
       guard let bio = bio else {return}
       guard let streetcred = wallet else {return}
       let ranking = Rank(id: uid, profileImageUrl: imageUrl, displayName: username, streetCred: streetcred, streetFollowers: 0, bio: bio, currentLevel: rank, totalSpots: totalSpotsPosted, totalStamps: totalStamps, totalSaves: totalSaves, totalUserVerifications: totalVerifications, totalPeopleMet: totalCities, totalCities: totalCities, progress: progressValue, social: nil)
      
       DataService.instance.saveUserRanking(rank: ranking)
   }
    
    
     func checkforNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                print("Notification is authorized")
                return
            case .denied:
                //request notification & save FCM token to DB
                print("Authorization Denied!")
                self.requestForNotification()
            case .notDetermined:
                //request notification & save FCM token to DB
                self.requestForNotification()
                print("Authorization Not determined")
            case .ephemeral:
                print("Notificaiton is ephemeral")
                return
            @unknown default:
                return
            }
            
            
        }
    }
    
     func requestForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            if let error = error {
                print("Error getting notification permission", error.localizedDescription)
            }
            
            
            if granted {
                print("Notification access granted")
                let fcmToken = Messaging.messaging().fcmToken ?? ""
                guard let uid = self.userId else {return}

                let data = [
                    UserField.fcmToken: fcmToken
                ]
                
                AuthService.instance.updateUserField(uid: uid, data: data)
            } else {
                print("Notification Authorization denied")
            }
            
        }
    }
    
    
}
