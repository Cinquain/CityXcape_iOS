//
//  FeedViewModel.swift
//  CityXcape
//
//  Created by James Allan on 7/21/22.
//

import Foundation
import SwiftUI



class FeedViewModel: ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    
    @Published var feeds: [Feed] = []
    @Published var users: [User] = []


    @Published var submissionText: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var newFeeds: Int = 0
    
    @Published var isSearching: Bool = false 
    @Published var showHeatmap: Bool = false
    @Published var showStreetPass: Bool = false
    @Published var showListView: Bool = false
    
    @Published var secretSpot: SecretSpot?
    @Published var verification: Verification?
    @Published var user: User?
    @Published var showUsers: Bool = false
    
    var searchTerm: String = "Search a user (case sensitive)"
    
    init() {
        
    }
    
    
     func fetchFeeds() {
        
        DataService.instance.getCityFeed { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let returnedFeeds):
                self.feeds = returnedFeeds
                self.feeds.sort(by: {$0.date > $1.date})
                self.newFeeds = returnedFeeds.count
            case .failure(let error):
                self.alertMessage = "Error getting feeds, \(error.localizedDescription)"
                self.showAlert = true
                return
            }
        }
        
    }

    
    func postMessage() {
        
        guard var wallet = wallet else {return}
        
        if wallet >= 1 {
            //Decremement wallet locally
            if submissionText.count < 2 {
                alertMessage = "Cannot broadcast empty message to the city"
                showAlert = true
                return
            }
            
            wallet -= 1
            UserDefaults.standard.set(wallet, forKey: CurrentUserDefaults.wallet)
            
            DataService.instance.postFeedMessage(content: submissionText, type: .feed, spotId: nil ) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                case .success(_):
                    self.alertMessage = "Message Sent. -1 StreetCred"
                    self.submissionText = ""
                    self.showAlert = true
                }
                
            }
            
        } else {
            self.alertMessage = "Insufficient StreetCred to Broadcast to the City"
            self.showAlert = true
        }
        //End of function
    }
    
    func removeListener() {
        DataService.instance.removeFeedListener()
    }
    
    
    func calculateView(feed: Feed) -> Text {
        switch feed.type {
            case .spot:
                return Text("\(feed.username) posted \(Image("pin_feed")) \(feed.content)")
            case .save:
                return Text("\(feed.username) just saved \(Image("pin_feed")) \(feed.content)")
            case .stamp:
                return Text("\(feed.username) checked-in \(Image("stamp_feed")) \(feed.content)")
            case .signup:
                return Text("\(feed.content) \(Image("grid_feed"))")
            case .message:
                return Text(feed.content)
            case .streetFollow:
                return Text("\(feed.username) started street following \(Image("Running_feed")) \(feed.content)")
            case .friends:
                return Text("\(feed.username) is now friends with \(feed.content)")
            case .share:
                return Text("\(feed.username) shared a spot \(Image("pin_feed")) with \(feed.content)")
            case .props:
                return Text("\(feed.username) gave \(Image("props_feed")) props to \(feed.content)'s stamps")
            case .trail:
                return Text("\(feed.username) posted a trail \(Image("trail_feed"))")
        }
    }
    
    func calculateAction(feed: Feed) {
        
        switch feed.type {
            case .signup:
                let user = User(feed: feed)
                self.user = user
            case .streetFollow:
                let user = User(id: feed.userId ?? "", displayName: feed.followingDisplayName ?? "", profileImageUrl: feed.followingImage ?? "")
                self.user = user
            case .stamp:
                getVerification(feed: feed)
            case .save, .share, .spot:
                getSecretSpot(spotId: feed.spotId ?? "")
            case .message:
                let user = User(feed: feed)
                self.user = user
            case .friends:
                let user = User(id: feed.userId ?? "", displayName: feed.followingDisplayName ?? "", profileImageUrl: feed.followingImage ?? "")
                self.user = user
            case .props:
                getPropsVerification(feed: feed)
            case .trail:
                getTrail(trailId: feed.spotId ?? "")
        }
        
    }
    
    func getSecretSpot(spotId: String) {
        DataService.instance.getSpecificSpot(postId: spotId) { [weak self] result in
            guard let self = self else {return}
                switch result {
                    case .failure(let error):
                        self.alertMessage = error.localizedDescription
                        self.showAlert = true
                    case .success(let spot):
                        print("Setting secret spot")
                        self.secretSpot = spot
                }
        }
    }
    
    func getTrail(trailId: String) {
        //Write code to fetch the specific trai object
        
        
    }
    
    func getVerification(feed: Feed) {
        let spotId = feed.spotId ?? ""
        let uid = feed.uid
        DataService.instance.getSpecificVerification(postId: spotId, uid: uid) { [weak self] result in
            guard let self = self else {return}
                switch result {
                    case .failure(let error):
                        self.alertMessage = error.localizedDescription
                        self.showAlert = true
                    case .success(let verification):
                        self.verification = verification
                }
        }                                                     
                                                
    }
    
    func getPropsVerification(feed: Feed) {
        let spotId = feed.spotId ?? ""
        let uid = feed.id
        
        DataService.instance.getSpecificVerification(postId: spotId, uid: uid) { [weak self] result in
            guard let self = self else {return}
                switch result {
                    case .failure(let error):
                        self.alertMessage = error.localizedDescription
                        self.showAlert = true
                    case .success(let verification):
                        self.verification = verification
                }
        }
    }
    
    func performSearch() {
        
        DataService.instance.searchForUsersWith(name: submissionText) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.showAlert.toggle()
                self.submissionText = ""
                self.isSearching.toggle()
            case .success(let returnedUsers):
                if returnedUsers.isEmpty {
                    print("No users found")
                    self.alertMessage = "No user found under that streetname"
                    self.showAlert.toggle()
                    self.submissionText = ""
                    self.isSearching.toggle()
                    return
                }
                self.users = returnedUsers
                self.isSearching.toggle()
                self.submissionText = ""
                self.showListView.toggle()
            }
        }
        
    }
    
}
