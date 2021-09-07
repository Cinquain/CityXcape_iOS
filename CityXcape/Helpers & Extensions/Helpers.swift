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
    static let dataCreated = "dataCreated"
    static let profileImageUrl = "profileImageUrl"
}

struct CurrentUserDefaults {
    
    static let displayName = "displayName"
    static let bio = "bio"
    static let userId = "userId"
    static let profileUrl = "profileImageUrl"
    
    
}

enum Icon: String {
    case pin = "pin_blue"
    case dot = "dot"
    case save = "save"
    case pass = "pass"
    case gear = "gears"
    case logo = "logo"
    case check = "checkmark"
    case globe = "globe"
    case unknown = "silhouette"
    case back = "back_arrow"
    case compass = "compass"
    case tabItemI = "tab1"
    case tabItemII = "tab2"
    case tabItemIII = "tab3"
    case history = "history"
}

enum Labels: String {
    case tab1 = "My Journey"
    case tab2 = "Post Spot"
    case tab3 = "StreetPass"

    case headerName = "Name"
    case headerDistance = "Distance"
    case headerPhoto = "Spot Image"
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
    }
}

struct StandardPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .brightness(configuration.isPressed ? 1.2 : 1.0)
        
    }
}
