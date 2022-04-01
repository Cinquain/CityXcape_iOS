//
//  TotalsViewModel.swift
//  CityXcape
//
//  Created by James Allan on 3/29/22.
//

import Foundation
import Combine

class TotalsViewModel: NSObject, ObservableObject {
    
    
    @Published var saveUsers: [User] = []
    @Published var verifiedUsers: [User] = []
    @Published var showUsersView: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
     func getImageName(type: AnalyticsType) -> String {
        switch type {
        case .comments:
            return "Total Comments"
        case .saves:
            return "Total Saves"
        case .checkins:
            return "Total Checkins"
        case .views:
            return "Total Views"
        }
    }
    
     func getCount(type: AnalyticsType, spot: SecretSpot) -> String {
        switch type {
        case .comments:
            return "\(spot.commentCount)"
        case .saves:
            return "\(spot.saveCounts)"
        case .checkins:
            return "\(spot.verifierCount)"
        case .views:
            return "\(spot.viewCount)"
        }
    }
    
     func imageName(type: AnalyticsType) -> String {
        switch type {
        case .comments:
            return "bubble.right.fill"
        case .saves:
            return "person.3.fill"
        case .checkins:
            return "figure.walk"
        case .views:
        return "eye"
        }
    }
    
     func getTitle(type: AnalyticsType) -> String {
        
        switch type {
        case .comments:
            return "Total Comments"
        case .saves:
            return "Total Saves"
        case .checkins:
            return "Total Checkins"
        case .views:
            return "Total Views"
        }
    }
    
    func handleButton(type: AnalyticsType, spot: SecretSpot) {
       switch type {
       case .comments:
           alertMessage = "Go to spot page to view comments"
           showAlert.toggle()
       case .saves:
           getSavedUsers(spot: spot)
           showUsersView.toggle()
       case .checkins:
           getVerifiedusers(spot: spot)
           showUsersView.toggle()
       case .views:
           return
       }
   }
    
    func timeStamp(type: AnalyticsType, user: User) -> String{
        
        if type == .checkins {
            return "Checked in on \n \(user.membership?.stringDescription() ?? "")"
        } else {
            return "Saved on \n \(user.membership?.stringDescription() ?? "")"
        }
        
    }
   
    
   fileprivate func getVerifiedusers(spot: SecretSpot) {
       DataService.instance.getVerifiersForSpot(postId: spot.id) { users in
           self.verifiedUsers = users
       }
    }
    
    fileprivate func getSavedUsers(spot: SecretSpot) {
        
        DataService.instance.getUsersForSpot(postId: spot.id, path: "savedBy") { users in
            self.saveUsers = users
        }
        
    }
    

    
    
    
}

