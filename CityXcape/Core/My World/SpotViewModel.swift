//
//  SpotViewModel.swift
//  CityXcape
//
//  Created by James Allan on 11/22/21.
//

import SwiftUI
import CoreLocation
import Combine
import FirebaseFirestore

class SpotViewModel: NSObject, ObservableObject {
    
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    
    @State var searchText: String = ""

    
    
    
    @Published var showActionSheet: Bool = false
    @Published var actionSheetType: SpotActionSheetType = .general
    
    
    @Published var comment: String = ""
    @Published var commentString: String = ""
    @Published var journeyImage: UIImage?
    @Published var showStamp: Bool = false
    @Published var showVerifiers: Bool = false
    @Published var showComments: Bool = false
    
    @Published var alertmessage: String = ""
    @Published var genericAlert: Bool = false
    @Published var didLike: Bool = false
    
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var showCheckin: Bool = false
    @Published var disableCheckin: Bool = false
    @Published var refresh: Bool = false
    
    
    @Published var showPicker: Bool = false
    @Published var addedImage: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Published var submissionText: String = ""
    @Published var comments: [Comment] = []
    @Published var users: [User] = []
    

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
        manager.fetchSecretSpots()
        
        DataService.instance.deleteSecretSpot(spot: spot) { success in
           
           if success {
               self.alertmessage = "This secret spot has been removed from your world"
               self.genericAlert.toggle()
               AnalyticsService.instance.deletePost()
               completion(success)
           } else {
               self.alertmessage = "There was an error in deleting this spot. Restart the app and try again"
               self.genericAlert.toggle()
               completion(success)
           }
       }
   }
    
    func getSavedbyUsers(postId: String) {
        
        DataService.instance.getUsersForSpot(postId: postId, path: "savedBy") { savedUsers in
            if savedUsers.isEmpty {
                print("No users saved this secret spot")
                self.users = []
            } else {
                self.users = savedUsers
            }
        }
    }
    
    func getVerifiedUsers(postId: String) {
        
        DataService.instance.getVerifiersForSpot(postId: postId) { users in
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
        
        if spot.distanceFromUser > 1 {
            return "\(String(format: "%.1f", spot.distanceFromUser)) miles"
        } else {
            return "\(String(format: "%.1f", spot.distanceFromUser)) mile"
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
    
    func getVerificationStamp(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
        
        if self.comment.isEmpty {
            alertMessage = "Leave a comment for your journey"
            showAlert = true
            return
        }
        
        if self.journeyImage == nil {
            alertMessage = "Take a picture for your journey"
            showAlert = true
            return
        }
        
        let image = journeyImage ?? UIImage()
        
        DataService.instance.verifySecretSpot(spot: spot, image: image, comment: comment) { [weak self] (success, message) in
            if success {
                self?.manager.updateVerification(spotId: spot.id, verified: true)
                completion(success)
            } else {
                self?.alertMessage = message ?? ""
                self?.showAlert = true
            }
        }
        
    }
    
    
    func updateSecretSpot(postId: String) {
        
        DataService.instance.updateSecretSpot(spotId: postId) { spot in
            
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
  
    
    
}
