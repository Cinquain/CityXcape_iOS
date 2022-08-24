//
//  JourneyViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/11/21.
//

import MapboxMaps
import SwiftUI
import Combine

class MyWorldViewModel: NSObject, ObservableObject {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    
    let manager = CoreDataManager.instance
    
    @Published var allSpots: [SecretSpot] = []
    @Published var currentSpots: [SecretSpot] = []
    @Published var users: [User] = []
    @Published var showOnboarding: Bool = false
    @Published var showVisited: Bool = false
    
    
    @Published var rank: String = ""
    @Published var progressString: String = ""
    @Published var progressValue: CGFloat = 0
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    
    @Published var annotations: [PointAnnotation] = []
    
    
    
    var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        setupToggleObserver()
    }
    
        
    
    func getSavedSpotsForUser(uid: String) {
        DataService.instance.getSpotsFromWorld(userId: uid) { [weak self] returnedSpots in
            guard let self = self else {return}
            if returnedSpots.isEmpty {
                print("No Secret Spots in array")
                self.showOnboarding = true
            } else {
                self.allSpots = returnedSpots
                self.currentSpots = self.allSpots.filter({$0.verified == false})
                self.showOnboarding = false
            }
        }
    }
    
    
    
    func setupToggleObserver() {
        
        $showVisited
            .sink { [weak self] showVisited in
                guard let self = self else {return}
                if showVisited {
                    self.currentSpots = self.allSpots.filter({$0.verified == true})
                } else {
                    self.currentSpots = self.allSpots.filter({$0.verified == false})
                }
            }
            .store(in: &cancellables)
    }
    
    func openGoogleMap(spot: SecretSpot) {
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
            
        } else {
            //Open in brower
            if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url)
            }
            
        }
    }
    
    
    func getSavedbyUsers(postId: String) {
        DataService.instance.getUsersForSpot(postId: postId, path: "savedBy") { savedUsers in
            if savedUsers.isEmpty {
                print("No users saved this secret spot")
                self.users = []
            } else {
                self.users = savedUsers
            }
        }
    }
    
    func getVerifiedUsers(postId: String) {
        
        
        DataService.instance.getUsersForSpot(postId: postId, path: "verifiers") { verifiedUsers in
            if verifiedUsers.isEmpty {
                print("No users verified this spot")
                self.users = []
            } else {
                self.users = verifiedUsers
            }
        }
    }
    
    func fetchSecretSpots() {
        
        let spots = manager.spotEntities.map({SecretSpot(entity: $0)})
        if spots.isEmpty {
            print("Core Data is Empty")
            guard let userId = self.userId else {return}
            self.getSavedSpotsForUser(uid: userId)
        } else {
            print("Core Data Entities Found!")
            self.allSpots.removeAll()
            self.annotations.removeAll()
            self.allSpots = spots
            self.currentSpots = self.allSpots.filter({$0.verified == false})
            let markers = self.currentSpots
                .map({PointAnnotation(coordinate: .init(latitude: $0.latitude, longitude: $0.longitude))})
            markers.forEach { point in
                var annotation = PointAnnotation(coordinate: point.point.coordinates)
                annotation.image = .init(image: createGridImage(), name: "grid")
                annotations.append(annotation)
            }
        }
        
            
    }
    
    func getDistanceMessage(spot: SecretSpot) -> String {
        
        if spot.distanceFromUser > 1 {
            return "\(String(format: "%.1f", spot.distanceFromUser)) miles"
        } else {
            return "\(String(format: "%.1f", spot.distanceFromUser)) mile"
        }
    }
    
    func performSearch(searchTerm: String) {
        if searchTerm.isEmpty {
            currentSpots  = allSpots.filter({$0.verified == false})
            return
        }
        currentSpots = allSpots.filter({$0.city.lowercased().contains(searchTerm.lowercased())
                    || $0.world.lowercased().contains(searchTerm.lowercased())
                    || $0.spotName.lowercased().contains(searchTerm.lowercased())})
        
    }
    
    func createGridImage() -> UIImage {
        let image = UIImage(named: "grid")!
        let targetSize = CGSize(width: 100, height: 100)
        let targetHeight = targetSize.height / image.size.height
        let targetWidth = targetSize.width / image.size.width
        let scaleFactor = min(targetWidth, targetHeight)
        let scaleImageSize = CGSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
        let renderer =  UIGraphicsImageRenderer(size: scaleImageSize)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaleImageSize))
        }
        return scaledImage
    }
    
    
    func calculateRank() {
        
        let allspots = manager.spotEntities.map({SecretSpot(entity: $0)})
        let verifiedSpots = allspots.filter({$0.verified == true})
        let totalStamps = verifiedSpots.count
        let ownerSpots = allspots.filter({$0.ownerId == userId})
        let totalSpotsPosted = ownerSpots.count
        let totalSaves = ownerSpots.reduce(0, {$0 + $1.saveCounts})
        var totalCities: Int = 0
        var cities: [String: Int] = [:]
        verifiedSpots.forEach { spot in
            if let count = cities[spot.city] {
                cities[spot.city] = count + 1
            } else {
                cities[spot.city] = 1
                totalCities += 1
            }
        }
        
        (self.rank,
         self.progressString,
         self.progressValue) = Rank.calculateRank(totalSpotsPosted: totalSpotsPosted, totalSaves: totalSaves, totalStamps: totalStamps)
        UserDefaults.standard.set(rank, forKey: CurrentUserDefaults.rank)
        
        
    }
    
    
    
    

    
    
}
