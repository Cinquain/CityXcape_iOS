//
//  NotificationsManager.swift
//  CityXcape
//
//  Created by James Allan on 11/2/21.
//

import Foundation
import Combine
import SwiftUI


class NotificationsManager: ObservableObject {
    
    @Published var hasNotification: Bool = false

    
     @State var username: String = ""
     @State var userImageUrl: String = ""
     @State var userBio: String = ""
     @State var uid: String = ""
     @State var streetcred: Int = 0
    
    
}
