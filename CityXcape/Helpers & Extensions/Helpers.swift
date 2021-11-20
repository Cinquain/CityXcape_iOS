//
//  Helpers.swift
//  CityXcape
//
//  Created by James Allan on 8/18/21.
//

import Foundation
import SwiftUI


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
    static let isPublic = "isPublic"
}

struct DatabaseReportField {
    
    static let content = "content"
    static let postId = "post_id"
    static let dateCreated = "date_created"
    static let ownerId = "owner_id"
}


struct CurrentUserDefaults {
    
    static let displayName = "displayName"
    static let bio = "bio"
    static let userId = "userId"
    static let profileUrl = "profileImageUrl"
    static let userLocation = "userLocation"
    static let wallet = "wallet"
    
}

enum Icon: String {
    case pin = "pin_blue"
    case dot = "dot"
    case save = "save"
    case pass = "pass"
    case gear = "Gears"
    case logo = "logo"
    case check = "checkmark"
    case globe = "globe"
    case unknown = "silhouette"
    case back = "back_arrow"
    case compass = "compass"
    case tabItem0 = "mission"
    case tabItemI = "my_world"
    case tabItemII = "tab2"
    case tabItemIII = "tab3"
    case history = "history"
}

enum Labels: String {
    case tab0 = "Discover"
    case tab1 = "My World"
    case tab2 = "Post Spot"
    case tab3 = "StreetPass"

    case headerName = "Name"
    case headerDistance = "Distance"
    case headerPhoto = "Spot Image"
}

enum SpotActionSheetType {
    case general
    case report
    case delete
}


enum SettingsEditTextOption {
    case displayName
    case bio
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
