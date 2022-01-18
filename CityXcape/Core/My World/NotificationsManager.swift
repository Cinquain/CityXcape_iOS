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
    
    
    static let instance = NotificationsManager()
    private init() {}
    
    @Published var hasNotification: Bool = false
    @Published var user: User?
    
    
    
}
