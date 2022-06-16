//
//  StorePageViewModel.swift
//  CityXcape
//
//  Created by James Allan on 6/14/22.
//

import Combine
import SwiftUI


class StorePageViewModel: NSObject, ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    
    override init() {
        super.init()
    }
    
    
    
    func updateStreetCred() {
        guard let uid = userId else {return}
        guard let streetCred = wallet else {return}
        let amount = streetCred + 100
        UserDefaults.standard.set(amount, forKey: CurrentUserDefaults.wallet)
        let data = [
            UserField.streetCred: amount
        ]
        AuthService.instance.updateUserField(uid: uid, data: data)
        AnalyticsService.instance.purchasedStreetCred()
        
    }
    
    
    
}
