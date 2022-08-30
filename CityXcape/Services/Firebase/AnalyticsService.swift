//
//  AnalyticsService.swift
//  CityXcape
//
//  Created by James Allan on 11/2/21.
//

import Foundation
import FirebaseAnalytics




class AnalyticsService {
    
    
    
    static let instance = AnalyticsService()
    
    
    func postSecretSpot() {
        Analytics.logEvent("spot_created", parameters: nil)
    }
    
    func savedSecretSpot() {
        Analytics.logEvent("save", parameters: nil)
    }
    
    func passedSecretSpot() {
        Analytics.logEvent("pass", parameters: nil)
    }
    
    func touchedSettings() {
        Analytics.logEvent("touched_settings", parameters: nil)
    }
    
    func createdBio() {
        Analytics.logEvent("created_bio", parameters: nil)
    }
    
    func viewStreetpass() {
        Analytics.logEvent("touched_streetcred", parameters: nil)
    }
    
    func viewedMission() {
        Analytics.logEvent("viewed_mission", parameters: nil)
    }
    
    func acceptedMission() {
        Analytics.logEvent("accepted_mission", parameters: nil)
    }
    
    func dismissedMission() {
        Analytics.logEvent("dismissed_mission", parameters: nil)
    }
    
    func viewedSecretSpot() {
        Analytics.logEvent("viewed_spot", parameters: nil)
    }
    
    func triedMessagingUser() {
        Analytics.logEvent("messaged_user", parameters: nil)
    }
    
    func droppedPin() {
        Analytics.logEvent("dropped_pin", parameters: nil)
    }
    
    func loadedNewSpots() {
        Analytics.logEvent("loaded_new_spots", parameters: nil)
    }
    
    func verify() {
        Analytics.logEvent("verification", parameters: nil)
    }
    
    func reportPost() {
        Analytics.logEvent("report_post", parameters: nil)
    }
    
    func touchedVerification() {
        Analytics.logEvent("attempt_verification", parameters: nil)
    }
    
    func deletePost() {
        Analytics.logEvent("deleted_post", parameters: nil)
    }
    
    func touchedProfile() {
        Analytics.logEvent("touched_user_profile", parameters: nil)
    }
    
    func touchedRoute() {
        Analytics.logEvent("clicked_route", parameters: nil)
    }
    
    func checkSavedUsers() {
        Analytics.logEvent("viewed_other_explorers", parameters: nil)
    }
    
    func viewedComments() {
        Analytics.logEvent("viewed_comments", parameters: nil)
    }
    
    func viewedDetails() {
        Analytics.logEvent("viewed_details", parameters: nil)
    }
    
    func postedComment() {
        Analytics.logEvent("posted_comment", parameters: nil)
    }
    
    func likedSpot() {
        Analytics.logEvent("liked_spot", parameters: nil)
    }
    
    func checkedVerifiers() {
        Analytics.logEvent("checked_verifiers", parameters: nil)
    }
    
    func checkedJournal() {
        Analytics.logEvent("checked_journal", parameters: nil)
    }
    
    func checkedCityStamp() {
        Analytics.logEvent("checked_city_stamp", parameters: nil)
    }
    
    func checkReportCard() {
        Analytics.logEvent("checked_report_card", parameters: nil)
    }
    
    func checkedStreetFollowers() {
        Analytics.logEvent("checked_street_followers", parameters: nil)
    }
    
    func updateSocialMedia() {
        Analytics.logEvent("updated_socialmedia", parameters: nil)
    }
    
    func shareSecretSpot() {
        Analytics.logEvent("share_spot", parameters: nil)
    }
    
    func shareStreetPass() {
        Analytics.logEvent("share_streetpass", parameters: nil)
    }
    
    func viewedLeaderBoard() {
        Analytics.logEvent("viewed_leaderboard", parameters: nil)
    }
    
    func viewedRanks() {
        Analytics.logEvent("viewed_ranks", parameters: nil)
    }
    
    func tappedBarCode() {
        Analytics.logEvent("tapped_barcode", parameters: nil)
    }
    
    func scannedBarCode() {
        Analytics.logEvent("scanned_barcode", parameters: nil)
    }
    
    func checkUserJourney() {
        Analytics.logEvent("checked_user_journey", parameters: nil)
    }
    
    func purchasedStreetCred() {
        Analytics.logEvent("purchased_streetcred", parameters: nil)
    }
  
    func createdTrail() {
        Analytics.logEvent("created_trail", parameters: nil)
    }
    
    func createdHunt() {
        Analytics.logEvent("created_hunt", parameters: nil)
    }
    
    func sentFriendRequest() {
        Analytics.logEvent("friend_request", parameters: nil)
    }
    
    func sentMessage() {
        Analytics.logEvent("sent_message", parameters: nil)
    }
    
    func newFriends() {
        Analytics.logEvent("new_friends", parameters: nil)
    }
    
    func streetFollowingUser() {
        Analytics.logEvent("street_following_user", parameters: nil)
    }
    
}
