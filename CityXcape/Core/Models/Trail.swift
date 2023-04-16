//
//  Trail.swift
//  CityXcape
//
//  Created by James Allan on 6/17/22.
//

import Foundation


struct Trail: Identifiable, Equatable {
    
    var id: String
    var name: String
    var imageUrls: [String]
    var description: String
    var ownerId: String
    var ownerDisplayName: String
    var ownerImageUrl: String
    var ownerRank: String
    var price: Int
    var spots: [String]
    var users: [String]
    var isHunt: Bool
    
    var startTime: Date?
    var endTime: Date?
    var longitude: Double?
    var latitude: Double?
    var tribe: String?
    var tribeImageUrl: String?
    
    
    
    static func == (lhs: Trail, rhs: Trail) -> Bool {
        lhs.id == rhs.id
    }
    
    init(data: [String:Any]?) {
        self.id = data?[TrailField.id] as? String ?? ""
        self.name = data?[TrailField.name] as? String ?? ""
        self.imageUrls = data?[TrailField.imageUrls] as? [String] ?? []
        self.description = data?[TrailField.description] as? String ?? ""
        self.ownerId = data?[TrailField.ownerId] as? String ?? ""
        self.ownerDisplayName = data?[TrailField.ownerName] as? String ?? ""
        self.ownerImageUrl = data?[TrailField.ownerImage] as? String ?? ""
        self.ownerRank = data?[TrailField.ownerRank] as? String ?? ""
        self.price  = data?[TrailField.price] as? Int ?? 10
        self.tribe = data?[TrailField.tribe] as? String ?? ""
        self.tribeImageUrl = data?[TrailField.tribeImageUrl] as? String ?? ""
        self.spots = data?[TrailField.spots] as? [String] ?? []
        self.users = data?[TrailField.users] as? [String] ?? []
        self.isHunt = false
    }

    
    init(huntData: [String: Any]?) {
        self.id = huntData?[TrailField.id] as? String ?? ""
        self.name = huntData?[TrailField.name] as? String ?? ""
        self.imageUrls = huntData?[TrailField.imageUrls] as? [String] ?? []
        self.description = huntData?[TrailField.description] as? String ?? ""
        self.ownerId = huntData?[TrailField.ownerId] as? String ?? ""
        self.ownerDisplayName = huntData?[TrailField.ownerName] as? String ?? ""
        self.ownerImageUrl = huntData?[TrailField.ownerImage] as? String ?? ""
        self.ownerRank = huntData?[TrailField.ownerRank] as? String ?? ""
        self.price  = huntData?[TrailField.price] as? Int ?? 10
        self.spots = huntData?[TrailField.spots] as? [String] ?? []
        self.users = huntData?[TrailField.users] as? [String] ?? []
        self.tribe = huntData?[TrailField.tribe] as? String ?? ""
        self.tribeImageUrl = huntData?[TrailField.tribeImageUrl] as? String ?? ""

        self.startTime = huntData?[TrailField.startDate] as? Date ?? Date()
        self.endTime = huntData?[TrailField.endDate] as? Date ?? Date()
        self.longitude = huntData?[TrailField.longitude] as? Double ?? 0.0
        self.latitude = huntData?[TrailField.latitude] as? Double ?? 0.0
        self.isHunt = true
    }
    
    static let data: [String: Any] = [
        TrailField.id: "12434",
        TrailField.name: "Prettiest Bathrooms in Minneapolis",
        TrailField.imageUrls: ["https://i2.wp.com/stepintoblacksburg.org/wp-content/uploads/2019/03/img9753.jpg?resize=1024%2C683&ssl=1", "https://i1.wp.com/stepintoblacksburg.org/wp-content/uploads/2019/03/newrivertrailstatepark.jpg?resize=1024%2C680&ssl=1", "https://i0.wp.com/stepintoblacksburg.org/wp-content/uploads/2019/03/pandapasnestrealty.jpg?resize=1024%2C684&ssl=1"],
        TrailField.description: "Nature trails that show off the best landscape views of Minneapolis",
        TrailField.ownerId: "L8f41O2WTbRKw8yitT6e",
        TrailField.ownerName: "Cinquain",
        TrailField.ownerImage: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=1a4c018a-d539-4c95-87ca-fdec61f8e73c",
        TrailField.ownerRank: "Scout",
        TrailField.price: 10,
        TrailField.spots: ["08C21E52-D0F1-4CEA-8A51-DB97F0D1F125","3ranFeNUnIgVmb1ZQEQR", "7yjGJhVjxLegLqvF9qyg", "9aIkNDODgHPaI8UW0hBP", "HxI5hu7MRV5H0Vxg7vqP", "JuP0FkQFe7J572q2oDdB", "M3IVMFu8SrcXb5ByjGBc", "LZ15QQX4K8g1uHVAS2Z0"],
        TrailField.tribe: "Scout",
        TrailField.tribeImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/Worlds%2FScout%2FScout.png?alt=media&token=d4320920-4644-4d99-8636-a3190378ed50",
        TrailField.users: ["L8f41O2WTbRKw8yitT6e", "dUBOGyE5nTBR3GluH5uA"]
    ]
    
    static let data2: [String: Any] = [
        TrailField.id: "124465749334",
        TrailField.name: "Street Art Hunt",
        TrailField.imageUrls: ["https://urban-nation.com/wp-content/uploads/2023/02/NK-UNartig-220618-0004-copy2.jpg", "https://news.artnet.com/app/news-upload/2021/04/GettyImages-1298369882-1024x683.jpg", "https://www.groningermuseum.nl/media/2/Tentoonstellingen/2021/Graffiti-in-Groningen/_2000xAUTO_fit_center-center_75_none/GM-Magazine_Streetart-KNELIS-037-DSC_5498.jpg"],
        TrailField.description: "Trail containing the best Street Art in NYC",
        TrailField.ownerId: "L8f41O2WTbRKw8yitT6e",
        TrailField.ownerName: "OmarOne",
        TrailField.ownerImage: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=1a4c018a-d539-4c95-87ca-fdec61f8e73c",
        TrailField.ownerRank: "Scout",
        TrailField.price: 10,
        TrailField.spots: ["08C21E52-D0F1-4CEA-8A51-DB97F0D1F125","3ranFeNUnIgVmb1ZQEQR", "7yjGJhVjxLegLqvF9qyg", "9aIkNDODgHPaI8UW0hBP", "HxI5hu7MRV5H0Vxg7vqP", "JuP0FkQFe7J572q2oDdB", "M3IVMFu8SrcXb5ByjGBc", "LZ15QQX4K8g1uHVAS2Z0"],
        TrailField.tribe: "Scout",
        TrailField.tribeImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/Worlds%2FShooters_Street_Art%2Flogo.png?alt=media&token=9cc115ec-1b65-4a4b-92fc-6c7173a7ce6b",
        TrailField.users: ["L8f41O2WTbRKw8yitT6e", "dUBOGyE5nTBR3GluH5uA"]
    ]
    
    static let demo = Trail(data: data)
    static let demo2 = Trail(data: data2)
}
