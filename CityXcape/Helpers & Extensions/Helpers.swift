//
//  Helpers.swift
//  CityXcape
//
//  Created by James Allan on 8/18/21.
//

import Foundation
import SwiftUI
import AVFoundation



enum DeepLink: String, CaseIterable {
    case home
    case discover
    case streetPass
}

enum Permissions: String {
    case idle = "Not Determined"
    case approved = "Access Granted"
    case denied = "Access Denied"
}

enum MessageType {
    case feed
    case spot
}

enum FormType {
    case spot
    case news
}

enum CardType {
    case trail
    case newTrail
    case hunt
}

enum SelectedBar: String, CaseIterable, Identifiable {
    var id: Self {self}
    case map
    case spots
    case completed
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
    static let tribe = "tribe"
    static let tribeImageUrl = "tribeImageUrl"
    static let tribeJoinDate = "tribeJoinDate"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let geohash = "geohash"
    static let nearbyToken = "nearbyToken"

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
    static let tribe = "tribe"
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
    static let members = "members"
    static let secret = "private"
    static let verified = "verified"
    static let nearby = "nearby"
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
    static let worlds = "worlds"
    static let maps = "maps"
    static let invite = "invite"
    static let comments = "comments"
    static let verifiers = "verifiers"
    static let chat = "chat"
    static let localFeed = "localFeeds"
    static let likedBy = "likedby"
    static let propsBy = "propsby"
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
    static let price = "price"
    static let world = "world"
    static let trailSpots = "trail_spots"
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
    static let tribe = "tribe"
    static let tribeImageUrl = "tribeImageUrl"
    static let incognito = "incognito"
    static let tribeJoinDate = "tribeJoinDate"
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
    static let isHunt = "isHunt"
    static let startDate = "start_date"
    static let endDate = "end_date"
    static let dateCreated = "date_created"
    static let tribe = "tribe"
    static let tribeImageUrl = "tribeImageUrl"
}

struct WorldField {
    static let id = "id"
    static let name = "worldName"
    static let description = "description"
    static let hashtags = "hashtags"
    static let initiationFee = "initiation_fee"
    static let imageUrl = "imageUrl"
    static let coverImageUrl = "cover_imageUrl"
    static let ownerImageUrl = "world_owner_imageUrl"
    static let spotCount = "spot_count"
    static let membersCount = "membership_count"
    static let monthlyFee = "monthly_fee"
    static let ownerId = "owner_id"
    static let dateCreated = "date_created"
    static let dateJoined = "date_joined"
    static let isPublic = "public"
    static let ownerEmail = "owner_email"
    static let ownerName = "owner_name"
    static let isApproved = "is_approved"
    static let reqString = "requirements"
    static let reqSpots = "req_spots"
    static let reqStamps = "req_stamps"
    static let ranks = "rankings"
    static let longitude = "longitude"
    static let latitude = "latitude"
    static let timestamp = "timestamp"
    static let geohash = "geohash"
    static let profileUrl = "profileImageUrl"
}

struct CheckinField {
    static let comment = "comment"
    static let comments = "comments"
    static let image =  "imageUrl"
    static let imageCollection = "imageCollection"
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
    static let propCount = "props_count"
    static let likedIds = "liked_ids"
    static let propIds = "prop_ids"
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
    case heart = "heart"
    case x = "x"
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
    case ribbon = "ribbon"
    case hive = "Hive"
    case heatmap = "orange-paths"
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
    case postalStam = "Postal_Stamp"
    case pin = "pin_blue"
    case stamp = "Stamp"
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
    case empty
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
    case trail
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


enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .pressing, .inactive:
            return false
        case .dragging:
            return true
        }
    }
    
    var isPressing: Bool {
        switch self {
        case .inactive:
            return false
        case .pressing, .dragging:
            return true
        }
    }
}

class QRScannerDelegae: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    
    @Published var scannedCode: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let code = readableObject.stringValue else {return}
            print(code)
            scannedCode = code
        }
    }
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

struct swipeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 128))
            .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)), radius: 12, x: 0, y: 0)
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
