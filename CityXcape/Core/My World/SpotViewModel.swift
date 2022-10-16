//
//  SpotViewModel.swift
//  CityXcape
//
//  Created by James Allan on 11/22/21.
//

import SwiftUI
import CoreLocation
import Combine
import CoreImage.CIFilterBuiltins
import FirebaseFirestore

class SpotViewModel: NSObject, ObservableObject, UIDocumentInteractionControllerDelegate {
    
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?

    
    @State var searchText: String = ""
    @Published var isLoading: Bool = false 
    @Published var showActionSheet: Bool = false
    @Published var actionSheetType: SpotActionSheetType = .general
    
    
    @Published var comment: String = ""
    @Published var commentString: String = ""
    @Published var journeyImage: UIImage?
    @Published var stampImage: UIImage?
    @Published var showStamp: Bool = false
    @Published var showVerifiers: Bool = false
    @Published var showComments: Bool = false
    
    @Published var showShareSheet: Bool = false
    @Published var alertmessage: String = ""
    @Published var genericAlert: Bool = false
    @Published var didLike: Bool = false
    
    @Published var presentScanner: Bool = false 
    @Published var isOwner: Bool = false
    @Published var showBarCode: Bool = false
    @Published var barcode: UIImage?
    
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var showRanks: Bool = false
    @Published var showCheckin: Bool = false
    @Published var disableCheckin: Bool = false
    @Published var refresh: Bool = false
    @Published var showFriendsList: Bool = false
    
    
    @Published var showPicker: Bool = false
    @Published var addedImage: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Published var submissionText: String = ""
    @Published var comments: [Comment] = []
    @Published var users: [User] = []
    @Published var rankings: [Rank] = []
    @Published var showLeaderboard: Bool = false 
    
    @Published var showShareView: Bool = false 
    @Published var rank: String = ""
    @Published var progressString: String = ""
    @Published var progressValue: CGFloat = 0
    @Published var showUsers: Bool = false

    
    
    let analytics = AnalyticsService.instance
    let manager = CoreDataManager.instance
    var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
    }
 
    
    func openGoogleMap(spot: SecretSpot) {
        AnalyticsService.instance.touchedRoute()
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
    
    func checkedOwner(spot: SecretSpot) {
        
        if spot.ownerId == userId {
            isOwner = true
        }
        
    }
    
    func spotDistance(spot: SecretSpot) -> Double {
        
        let manager = LocationService.instance.manager
        let spotLocation = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
        let userLocation = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
        let distance = userLocation.distance(from: spotLocation) * 3.28084
     
        return distance
    
    }
    
    func showWorldDefinition(spot: SecretSpot) {
        self.showAlert = true
        self.alertMessage = "This spot is for the \(spot.world) community"
    }
   
    
    func reportPost(reason: String, spot: SecretSpot) {
          print("Reporting post")
          AnalyticsService.instance.reportPost()
          DataService.instance.uploadReports(reason: reason, postId: spot.id) { success in
              
              if success {
                  self.alertmessage = "Thank you for reporting this spot. We will review it shortly!"
                  self.genericAlert.toggle()
              } else {
                  self.alertmessage = "There was an error reporting this secret spot. Please restart the app and try again."
                  self.genericAlert.toggle()
              }
          }

      }
    
    
    func deletePost(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
        
        manager.delete(spotId: spot.id)
        
        DataService.instance.deleteSecretSpot(spot: spot) { [weak self] success in
            guard let self = self else {return}
            
           if success {
               self.alertmessage = "This secret spot has been removed from your world"
               self.genericAlert.toggle()
               AnalyticsService.instance.deletePost()
               self.manager.fetchSecretSpots()
               completion(success)
           } else {
               self.alertmessage = "There was an error in deleting this spot. Restart the app and try again"
               self.genericAlert.toggle()
               completion(success)
           }
       }
   }
    
    func loadBarCode(spot: SecretSpot) {
        
        if spot.id == userId {
            showBarCode = true
        } else {
            sourceType = .camera
            showPicker = true
        }
        AnalyticsService.instance.tappedBarCode()
    }
    
    func getSavedbyUsers(postId: String) {
        
        DataService.instance.getUsersForSpot(postId: postId, path: "savedBy") { [weak self] savedUsers in
            guard let self = self else {return}
            if savedUsers.isEmpty {
                print("No users saved this secret spot")
                self.users = []
            } else {
                self.users = savedUsers
            }
        }
    }
    
    func getVerifiedUsers(postId: String) {
        
        DataService.instance.getVerifiersForSpot(postId: postId) { [weak self] users in
            guard let self = self else {return}
            if users.isEmpty {
                print("No users verified this spiot")
                self.users = []
                return
            } else {
                self.users = users
            }
        }
        
    }
    
    
    func getDistanceMessage(spot: SecretSpot) -> String {
        
        if spot.distanceFromUser < 1 {
            return "\(String(format: "%.1f", spot.distanceFromUser)) mile"
        } else if spot.distanceFromUser < 10 {
            return "\(String(format: "%.1f", spot.distanceFromUser)) miles"
        } else {
            return "\(spot.city)"
        }
    }
    
    func getViews(spot: SecretSpot) -> String {
        if spot.viewCount > 1 {
            return "\(spot.viewCount) views"
        } else {
            return "\(spot.viewCount) view"
        }
    }
    
   func getSavesMessage(spot: SecretSpot) -> String {
        if spot.viewCount > 1 {
            return "\(spot.saveCounts) saves"
        } else {
            return "\(spot.saveCounts) save"
        }
    }
    
    func generateBarCode(spot: SecretSpot) -> UIImage {
        let filter = CIFilter.qrCodeGenerator()
        let context = CIContext()
        let spotId = spot.id
        let data = spotId.data(using: String.Encoding.ascii)
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 4, y: 4)

        if let qrCodeImage = filter.outputImage?.transformed(by: transform) {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        
        return UIImage(systemName: "xmark") ?? UIImage()
    }
    
    
    func isTextAppropriate() -> Bool {
        
        let badWords = ["shit", "ass", "dick", "fuck", "bitch", "nigger", "cracker", "nigga"]
        let words = submissionText.components(separatedBy: " ")
        
        for word in words {
            if badWords.contains(word) {
                return false
            }
        }
        
        if submissionText.count < 3 {
            return false
        }
        
        return true
    }
    
    func uploadComment(postId: String) {
        
        guard let uid = userId else {return}
        guard let username = displayName else {return}
        guard let bio = bio else {return}
        guard let imageUrl = profileUrl else {return}
        self.comment = submissionText
        
        DataService.instance.postComment(postId: postId, uid: uid, username: username, bio: bio, imageUrl: imageUrl, content: submissionText) { success, commentId in
            
            if !success {
                print("Error saving comment to database")
                self.submissionText = ""
                return
            }
            print("Successfully uploaded comment to database")
            guard let id = commentId else {return}
            let comment = Comment(id: id, uid: uid, username: username, imageUrl: imageUrl, bio: bio, content: self.submissionText, dateCreated: Date())
            self.comments.append(comment)
            self.submissionText = ""
            
        }
        
    }
    
    func presentShareSheet(spot: SecretSpot) {
        
        let name = spot.spotName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let description = spot.description ?? ""
        let spotId = spot.id
        let scheme = "cityxcape://discover//\(spotId)"
        let formattedDescription = description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let image = "https://www.cityxcape.com/assets/blog/assets/data/data7.jpg"
        let link = "https://link.cityxcape.com/?link=https://www.cityxcape.com&isi=1588136633&ibi=\(scheme)&st=\(name)&sd=\(formattedDescription)&si=\(image)"
        guard let urlShare = URL(string: link) else {return}
        
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.presentedViewController?.present(activityVC, animated: true, completion: nil)
        
    }
    
    func shareStampImage(spot: SecretSpot) {
        stampImage = generateStampImage(spot: spot)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.showShareSheet.toggle()
        }
    }
    
    func shareInstaStamp(spot: SecretSpot) { 
        let image = journeyImage ?? UIImage()
        let passportImage = StampImage(image: image, title: spot.spotName, date: Date(), comment: comment)
                            .snapshot()
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: passportImage)
        
        guard let instagramUrl = URL(string:"instagram://share") else {return}
       
        
        if UIApplication.shared.canOpenURL(instagramUrl) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
            }
        } else {
            print("Cannot Find Instagram on Device")
        }
    }
    
    func generateStampImage(spot: SecretSpot) -> UIImage {
        return StampImage(image: journeyImage ?? UIImage(), title: spot.spotName, date: Date(), comment: comment).snapshot()
    }
    
    func getComments(postId: String) {
        DataService.instance.downloadComments(postId: postId) { comments in
            if comments.isEmpty {
                print("No Comments Found")
                self.commentString = "No comment yet posted"
                return
            }
            
            
            print("Found comments")
            self.comments = comments
            
            if comments.count <= 1 {
                self.commentString = "\(comments.count) comment"
            } else {
                self.commentString = "\(comments.count) comments"
            }
            
        }
    }
    
    func updateVerificationStamp(spot: SecretSpot, completion: @escaping (Bool) -> Void) {
        isLoading = true
        if let lastDate = spot.lastVerified {
           let now = Date()
           let minimumTime: TimeInterval = 60 * 60 * 24
           let timeInterval = lastDate.timeIntervalSince(now)
            if timeInterval < minimumTime {
                self.alertmessage = "You can only check-in once per day"
                self.showAlert = true
                isLoading = false
                completion(false)
                return
            }
        }
        
        
        DataService.instance.updateStamp(spot: spot, image: journeyImage, comment: comment) { result in
            switch result {
            case .success(let complete):
                completion(complete)
            case .failure(let error):
                print("Error updating stamp", error.localizedDescription)
                self.alertmessage = "Error updating stamp"
                self.showAlert = true
            }
        }
        
    }
    
    
    func getVerificationStamp(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
            isLoading = true

            if self.comment.isEmpty {
                alertMessage = "Leave a comment for your journey"
                showAlert = true
                isLoading = false
                return
            }
            
            if self.journeyImage == nil {
                alertMessage = "Take a picture for your journey"
                showAlert = true
                isLoading = false
                return
            }
        
            let imageSave = ImageSaver()
            let image = journeyImage ?? UIImage()
            imageSave.writeToPhotoAlbum(image: image)
            
            DataService.instance.verifySecretSpot(spot: spot, image: image, comment: comment) { [weak self] (success, message) in
                guard let self = self else {return}
                if success {
                    self.manager.updateVerification(spotId: spot.id, verified: true)
                    completion(success)
                } else {
                    self.isLoading = false
                    self.alertMessage = message ?? "Failed to verifiy Secret Spot"
                    self.showAlert = true
                }
            }
        
        
    }
    
    
    func updateSecretSpot(postId: String, completion: @escaping (_ success: Bool) -> ()) {
        
        DataService.instance.updateSecretSpot(spotId: postId) { success in
            completion(success)
        }
        

    }
    
    func pressLike(postId: String) {
        
        if didLike {
            DataService.instance.likeSpot(postId: postId)
            AnalyticsService.instance.likedSpot()
        } else {
            DataService.instance.unliKeSpot(postId: postId)
        }
        manager.updateLike(spotId: postId, liked: didLike)

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
        let totalVerifications = ownerSpots.reduce(0, {$0 + $1.verifyCount})
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
    
    
    func checkIfPresent(spot: SecretSpot) {
        let manager = LocationService.instance.manager
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            let manager = LocationService.instance.manager
            let spotLocation = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
            let userLocation = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
            let distance = userLocation.distance(from: spotLocation)
            let distanceInFeet = distance * 3.28084
            if distanceInFeet < 200 {
                showCheckin = true
            }
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    func checkInWithQrCode(spot: SecretSpot, qrString: String) {
        AnalyticsService.instance.scannedBarCode()
        if spot.id == qrString {
            self.showCheckin = true
        } else {
            self.alertMessage = "This QR code is not for this spot"
            self.showAlert = true
        }
    }
    
    
    func shareSecretSpot(spot: SecretSpot, user: User) {
        DataService.instance.shareSecretSpot(user: user, spot: spot) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let message):
                self.alertMessage = message
                self.showAlert = true
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    func getFriends() {
        DataService.instance.getFriendsForUser { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.showAlert.toggle()
            case .success(let friends):
                self.users = friends
                self.showFriendsList.toggle()
            }
        }
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
