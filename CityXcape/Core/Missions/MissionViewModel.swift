//
//  MissionViewModel.swift
//  CityXcape
//
//  Created by James Allan on 10/4/21.
//

import Foundation
import Combine
import MapKit



class MissionViewModel: ObservableObject {

    
    @Published var standardMissions: [Mission] = []
    @Published var userMissions: [SecretSpot] = []
    @Published var lastSecretSpot: String = ""
    
    @Published var hasUserMissions: Bool = false
    
    init() {
        let missionOne = Mission(title: "Post a Secret Spot", imageurl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/missions%2Fexplore.png?alt=media&token=9f2dfb67-6a1c-40f7-8a32-78273d4119f7", description: "Help the scout community grow by posting a secret spot. Secret Spots are cool places not known by most people. You get 5 StreetCred for posting your first spot.", world: "ScoutLife", region: "United States", bounty: 5, owner: "CityXcape", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/CityXcape%2Fcx.png?alt=media&token=4f8b0b0a-ea9d-412e-8e6f-dbd00960a6c7")
        
        standardMissions.append(missionOne)
       
        if userMissions.count > 0 {
            hasUserMissions = true
        }
        
        DataService.instance.getNewSecretSpots(lastSecretSpot: lastSecretSpot) { [weak self] secretspots in
            
            self?.userMissions = secretspots
        }
        
//
//        let userMission = SecretSpot(postId: "45480586040400358", spotName: "The Eichler Home", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/missions%2Fexplore.png?alt=media&token=9f2dfb67-6a1c-40f7-8a32-78273d4119f7", longitude: 39.784352, latitude: -86.093180, address: "1229 Spann Ave", city: "Indianapolis", zipcode: 46203, world: "Surfers", dateCreated: Date(), viewCount: 4, price: 1, saveCounts: 30, isPublic: true, description: "This is the best spot in the world", ownerId: "Cinquain", ownerDisplayName: "Erin", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FhotK4d2IZDYs0wjlKc3A%2FprofileImage?alt=media&token=57e6e26b-ffef-4d31-be3a-db599c4c97a9")
//
//        let userMission2 = SecretSpot(postId: "20394045950605", spotName: "Secret Gun Club", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2FE84Z8SAzgXRcdbMaAfuo%2F1?alt=media&token=ef6978b8-0586-4071-a5ad-f0cce0ac8f98", longitude: 39.784352, latitude: -86.093180, address: "1229 Spann Ave", city: "Indianapolis", zipcode: 46203, world: "Surfers", dateCreated: Date(), viewCount: 4, price: 1, saveCounts: 30, isPublic: true, description: "This is the best spot in the world", ownerId: "Cinquain", ownerDisplayName: "Erin", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FhotK4d2IZDYs0wjlKc3A%2FprofileImage?alt=media&token=57e6e26b-ffef-4d31-be3a-db599c4c97a9")
//
//        let userMission3 = SecretSpot(postId: "45858959495858494", spotName: "The Eichler Home", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2FF6L9CJzmFMfb0lqBfTtb%2F1?alt=media&token=098ee3be-b39c-4065-b59f-92e4fe9fc335", longitude: 39.784352, latitude: -86.093180, address: "1229 Spann Ave", city: "Indianapolis", zipcode: 46203, world: "Surfers", dateCreated: Date(), viewCount: 4, price: 1, saveCounts: 30, isPublic: false, description: "This is the best spot in the world", ownerId: "Cinquain", ownerDisplayName: "Erin", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FhotK4d2IZDYs0wjlKc3A%2FprofileImage?alt=media&token=57e6e26b-ffef-4d31-be3a-db599c4c97a9")
//
//        let userMission4 = SecretSpot(postId: "123447574848595959", spotName: "Secret Car Show", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2FRKspLHs7noIlleaWbYkG%2F1?alt=media&token=6384c6c0-6765-4097-80c9-395873e21c33", longitude: 39.784352, latitude: -86.093180, address: "1229 Spann Ave", city: "Indianapolis", zipcode: 46203, world: "Surfers", dateCreated: Date(), viewCount: 4, price: 1, saveCounts: 30, isPublic: false, description: "This is the best spot in the world", ownerId: "Cinquain", ownerDisplayName: "Erin", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FhotK4d2IZDYs0wjlKc3A%2FprofileImage?alt=media&token=57e6e26b-ffef-4d31-be3a-db599c4c97a9")
        
       
    }
    
    
}
