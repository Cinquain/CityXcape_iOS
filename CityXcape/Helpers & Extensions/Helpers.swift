//
//  Helpers.swift
//  CityXcape
//
//  Created by James Allan on 8/18/21.
//

import Foundation
import SwiftUI



enum DeepLink: String, CaseIterable {
    case home
    case discover
    case streetPass
}

struct Keys {
    static let proxy = "proxy"
}

struct UserField {
    static let displayName = "displayName"
    static let email = "email"
    static let providerId = "provider_id"
    static let provider = "provider"
    static let bio = "bio"
    static let dataCreated = "dateCreated"
    static let profileImageUrl = "profileImageUrl"
    static let streetCred = "streetCred"
    static let fcmToken = "fcmToken"
    static let ig = "instagram"
    static let world = "world"
    static let community = "top_world"
    static let rank = "rank"
    static let city = "city"
}

struct SecretSpotField {
    
    static let spotName = "spot_name"
    static let description = "description"
    static let spotImageUrl = "spot_image_url"
    static let address = "address"
    static let spotId = "spot_id"
    static let ownerId = "owner_id"
    static let ownerDisplayName = "ownerDisplayName"
    static let ownerImageUrl = "ownerImageUrl"
    static let verifierImages = "verifier_images"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let dateCreated = "date_created"
    static let price = "price"
    static let saveCount = "save_count"
    static let viewCount = "view_count"
    static let city = "city"
    static let zipcode = "zip_code"
    static let verified = "verified"
    static let world = "world"
    static let geohash = "geohash"
    static let isPublic = "isPublic"
    static let spotImageUrls = "spotImageUrls"
    static let likeCount = "like_count" //Int
    static let likedBy = "liked_by" //Array
    static let verifierCount = "verifier_count"
    static let commentCount = "comment_count"
    static let ownerIg = "owner_ig"
}

struct CommentField {
    static let id = "id"
    static let uid = "user_id"
    static let username = "display_name"
    static let imageUrl = "profile_image"
    static let bio = "user_bio"
    static let content = "message"
    static let dateCreated = "date_created"
}



struct RankingField {
    static let id = "uid"
    static let profileUrl = "profile_url"
    static let displayName = "display_name"
    static let streetcred = "streetcred"
    static let streetFollowers = "street_followers"
    static let bio = "bio"
    static let level = "current_level"
    static let totalSpots = "total_spots_posted"
    static let totalStamps = "total_stamps"
    static let totalSaves = "total_saves"
    static let totalVerifications = "total_verifications"
    static let totalPeopleMet = "total_users_met"
    static let cities = "cities_visited"
    static let totalCities = "city_count"
    static let progress = "progress"
    static let ig = "instagram"
    static let totalTrails = "total_trails"
    static let totalHunts = "total_hunts"
}

struct DatabaseReportField {
    
    static let content = "content"
    static let postId = "post_id"
    static let dateCreated = "date_created"
    static let ownerId = "owner_id"
}

struct ServerPath {
    static let followers = "followers"
    static let following = "following"
    static let history = "history"
    static let secret = "private"
    static let verified = "verified"
    static let posts = "posts"
    static let rankings = "rankings"
    static let users = "users"
    static let world = "world"
    static let trail = "trails"
    static let hunt = "hunts"
    static let cities = "cities"
    static let secure = "private"
    static let feed = "feed"
    static let report = "reports"
    static let save = "savedBy"
    static let friends = "friends"
    static let request = "request"
    static let messages = "messages"
    static let recentMessage = "recent_messages"
    static let shared = "shared"
}

struct FeedField {
    static let id = "id"
    static let uid = "uid"
    static let username = "username"
    static let profileUrl = "profile_url"
    static let bio = "user_bio"
    static let rank = "user_rank"
    static let content = "content"
    static let date = "date"
    static let type = "type"
    static let geohash = "geohash"
    static let longitude = "longitude"
    static let latitude = "latitude"
    static let stamp = "stamp"
    static let spot = "spot"
    static let message = "message"
    static let spotId = "post_id"
    static let userId = "user_id"
    static let stampImageUrl = "stamp_image"
    static let followingImage = "following_image"
    static let followingName = "following_username"
}

struct CurrentUserDefaults {
    
    static let displayName = "displayName"
    static let bio = "bio"
    static let userId = "userId"
    static let profileUrl = "profileImageUrl"
    static let userLocation = "userLocation"
    static let wallet = "wallet"
    static let social = "instagram"
    static let loadMessgae = "loadMessage"
    static let city = "city"
    static let rank = "rank"
    static let world = "world"
}

struct TrailField {
    static let id = "id"
    static let name = "name"
    static let description = "description"
    static let imageUrls = "image_urls"
    static let price = "price"
    static let ownerId = "owner_id"
    static let world = "world"
    static let ownerName = "owner_name"
    static let ownerImage = "owner_image_url"
    static let ownerRank = "owner_rank"
    static let spots = "spots"
    static let users = "users"
    static let address = "address"
    static let city = "city"
    static let longitude = "longitude"
    static let latitude = "latitude"
    static let startDate = "start_date"
    static let endDate = "end_date"
    static let dateCreated = "date_created"
}

struct CheckinField {
    static let comment = "comment"
    static let image =  "imageUrl"
    static let veriferName = "verifierName"
    static let verifierImage = "verifierImageUrl"
    static let verifierId =  "verifierId"
    static let spotOwnerId =  "spotOwnerId"
    static let spotId = "postId"
    static let city =   "city"
    static let spotName =  "name"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let country =  "country"
    static let timestamp = "time"
    static let commentCount = "comment_count"
    static let checkinCount = "check-in_count"
    static let checkins = "checkins"
    static let likeCount = "like_count"
    static let props = "props_count"
}

struct MessageField {
    static let id = "id"
    static let fromId = "fromId"
    static let toId = "toId"
    static let content = "content"
    static let timestamp = "timestamp"
    static let profileUrl = "profileUrl"
    static let displayName = "displayName"
    static let rank = "rank"
    static let bio = "bio"
    static let userId = "userId"
}

enum Icon: String {
    case pin = "pin_blue"
    case dot = "dot"
    case save = "save"
    case pass = "pass"
    case gear = "Gears"
    case logo = "logo"
    case refresh = "refresh"
    case check = "checkmark"
    case globe = "globe"
    case unknown = "silhouette"
    case back = "back_arrow"
    case compass = "Scout-Logo"
    case tabItem0 = "mission"
    case tabItemI = "my_world"
    case tabItemII = "tab2"
    case tabItemIII = "tab3"
    case grid = "grid_tab"
    case history = "history"
}

enum Labels: String {
    case tab0 = "Feed"
    case tab1 = "My Spots"
    case tab2 = "Discover"
    case tab3 = "Post Spot"
    case tab4 = "StreetPass"
    

    case headerName = "Name"
    case headerDistance = "Distance"
    case headerPhoto = "Spot Image"
}

enum SpotActionSheetType {
    case general
    case report
    case delete
}

enum CardActionSheet {
    case general
    case report
}

enum SettingsEditTextOption {
    case displayName
    case bio
    case social
}

enum Currency: String {
    case stc
    case usd
}

enum DetailsMode {
    case SpotDetails
    case CardView
}

enum SecretSpotImageNumb: CaseIterable {
    case one
    case two
    case three
}

enum Path: String {
    case savedBy
    case verifiers
}

enum AnalyticsType: String, Identifiable {
    var id : RawValue { rawValue }
    
    case comments
    case saves
    case checkins
    case views 
}

enum PurchaseError: Error {
    case failed
}

enum UploadError: Error {
    case failed 
}

enum NetworkError: Error {
    case failed
    case badURL
}

enum FeedType: String, CaseIterable {
    case stamp
    case spot
    case message
    case save
    case streetFollow
    case signup
    case friends
    case share
    case props
}


enum Ranking: String {
     case Tourist
     case Visitor
     case Observer
     case Local
     case Informant
     case Scout
     case Recon
     case ForceRecon
     case Bond = "007"
}




struct StandardButton: ViewModifier {
    
    let textColor: Color
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(textColor)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(8)
            .shadow(radius: 10)
            .padding()
            .padding(.horizontal, 40)
    }
}

struct StandardPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .brightness(configuration.isPressed ? 1.2 : 1.0)
        
    }
}

let spotCompleteNotification = Notification.Name(rawValue: "completeSpot")
