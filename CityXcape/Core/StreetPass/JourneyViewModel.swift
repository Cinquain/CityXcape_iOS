//
//  JourneyViewModel.swift
//  CityXcape
//
//  Created by James Allan on 3/3/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class JourneyViewModel: NSObject, ObservableObject {
    
    
    @Published var verifications: [Verification] = []
    @Published var cities: [String: Int] = [:]
    @Published var showCollection: Bool = false
    @Published var showJournal: Bool = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    override init() {
        super.init()
        getVerificationForUser()
    }
    
    fileprivate func getCities() {
            
        verifications.forEach { verification in

            if let count = cities[verification.city] {
                cities[verification.city] = count + 1
            } else {
            
                cities[verification.city] = 1
            }
        }
        
    }
    
    fileprivate func getVerificationForUser() {
        DataService.instance.getVerifications { [weak self] verifications in
            self?.verifications = verifications
            self?.getCities()
        }
    }
    
    
    func openJournal() {
        AnalyticsService.instance.checkedJournal()
        if verifications.isEmpty {
            alertMessage = "You have no stamps in your journal. \n Go check in a location to get stamped."
            showAlert = true
        } else {
            showJournal = true
        }
    }
    
    func openCollection() {
        AnalyticsService.instance.checkedCityStamp()
        if cities.isEmpty {
            alertMessage = "You have no cities stamped in your journal. \n Go check into a location to get stamped."
            showAlert = true
        } else {
            showCollection = true
        }
    }
    
    func locationMessage() -> String {
        if verifications.count > 1 {
            return "\(verifications.count) Locations"
        } else {
            return "\(verifications.count) Location"
        }
    }
    
    func cityMessage() -> String {
        if cities.keys.count > 1 {
            return "\(cities.keys.count) Cities"
        } else {
            return "\(cities.keys.count) City"
        }
    }
    
    
    
    fileprivate func createdData() {
    let data: [String: Any] = [
        "comment": "This place has a working enigma machine. How much cooler can it get?",
            "imageUrl": "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2FoUd8psjb5eaXnsHzHCJJ%2F1?alt=media&token=474e43d7-989e-4c6b-9726-9926802d928b",
            "verifierId": "abffowa",
            "spotOwnerId": "abxyrh",
            "city": "Annapolis Junction",
            "country": "United States",
            "time": FieldValue.serverTimestamp(),
            "latitude": 39.11482005300535,
            "longitude": -76.77468717098236,
            "postId": "xyateyigopuoz123",
            "name": "National Cryptologic Museum"
    ]
    
    let data2: [String: Any] = [
        "comment": "This place is amazing. World's finest Mosaic",
            "imageUrl": "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F3rD6bKzwCbOEpfU51sYF%2F1?alt=media&token=2c45942e-5a44-4dd1-aa83-a678bb848c4b",
            "verifierId": "abffowa",
            "spotOwnerId": "abxyrh",
            "city": "Philadelphia",
            "country": "United States",
            "time": FieldValue.serverTimestamp(),
            "latitude":39.9427079,
            "longitude": -75.1593136,
            "postId": "xyziusfdsgf123",
            "name": "The Magic Garden"
    ]
    
    let data3: [String: Any] = [
        "comment": "The Autodesk staff was amazingly hospitable",
            "imageUrl": "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F7ZU7v2qaVzlN8R0iFvlk%2F1?alt=media&token=21b1be3f-44bf-4d15-b9ef-8dfc78776355",
            "verifierId": "abffowa",
            "spotOwnerId": "abxyrh",
            "city": "San Francisco",
            "country": "United States",
            "time": FieldValue.serverTimestamp(),
            "latitude": 37.7939222,
            "longitude": -122.394815,
            "postId": "xyz12sdhfidshf3",
            "name": "AutoDesk Gallery"
    ]
    
    
    let data6: [String: Any] = [
        "comment": "This is coffee heaven for real",
            "imageUrl": "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2FRd3gMuBGbvgA18CSvHgg%2F1?alt=media&token=7b1d2452-c905-4439-802e-8ac8dea77d4c",
            "verifierId": "abffowa",
            "spotOwnerId": "abxyrh",
            "city": "San Francisco",
            "country": "United States",
            "time": FieldValue.serverTimestamp(),
            "latitude": 40.741540612676346,
            "longitude": -74.00536805391312,
            "postId": "xyrgyjsdbz123",
            "name": "Starbucks Reserve Roasters"
    ]
    
    let data4: [String: Any] = [
        "comment": "This museum makes you want to go to MIT.",
            "imageUrl": "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2FEh02xKtGRDCgGKRUDLPf%2F1?alt=media&token=94cdd31e-d095-4946-8092-e35b85cb2aa1",
            "verifierId": "abffowa",
            "spotOwnerId": "abxyrh",
            "city": "Cambridge",
            "country": "United States",
            "time": FieldValue.serverTimestamp(),
            "latitude": 42.3621321,
            "longitude": -71.0866651,
            "postId": "dsuisirxyz123",
            "name": "MIT Museum"
    ]
    
    let data5: [String: Any] = [
        "comment": "What a book collection... Wow!",
            "imageUrl": "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F3jZnROsqclDPUl6035VP%2F1?alt=media&token=9c66639e-ab31-485f-a71f-ea70d1891b81",
            "verifierId": "abffowa",
            "spotOwnerId": "abxyrh",
            "city": "New York",
            "country": "United States",
            "time": FieldValue.serverTimestamp(),
            "latitude": 40.74917517282669,
            "longitude": -73.9813756942749,
            "postId": "xyz1sdiffgdsh23",
            "name": "The Morgan Library"
    ]
    
    let verifation = Verification(data: data)
    let verifation2 = Verification(data: data2)
    let verifation3 = Verification(data: data3)
    let verifation4 = Verification(data: data4)
    let verifation5 = Verification(data: data5)
    let verifation6 = Verification(data: data6)
    let array: [Verification] = [verifation, verifation2, verifation3, verifation4, verifation5, verifation6]
    verifications.append(contentsOf: array)

    
    }
    
    
}
