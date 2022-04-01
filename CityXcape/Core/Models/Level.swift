//
//  Rank.swift
//  CityXcape
//
//  Created by James Allan on 3/21/22.
//

import Foundation
import UIKit


struct Level: Identifiable, Hashable {
    
    let id: String
    let imageName: String
    let requirement: String
    let description: String
    
    let spots: Int
    let stamps: Int
    let saves: Int
    let friends: Int
    let cities: Int
    let mission: Int
    let trails: Int
    
    
    private static let tourist = Level(id: "Tourist", imageName: "tourist", requirement: "None", description: "You don't know sh*&", spots: 0, stamps: 0, saves: 0, friends: 0, cities: 0, mission: 0, trails: 0)
    private static let visitor = Level(id: "Visitor", imageName: "traveler", requirement: "Post a spot that is saved by at least one person", description: "Ok You're trying...", spots: 1, stamps: 0, saves: 1, friends: 0, cities: 0, mission: 0, trails: 0)
    private static let observer = Level(id: "Observer", imageName: "observer", requirement: "Post three spots that get at least 10 saves", description: "You're learning the streets", spots: 3, stamps: 0, saves: 10, friends: 0, cities: 0, mission: 0, trails: 0)
    private static let local = Level(id: "Local", imageName: "local", requirement: "Post 10 spots for 50 saves, and get 3 stamps", description: "You know the city",spots: 10, stamps: 3, saves: 50, friends: 0, cities: 0, mission: 0, trails: 0)
    private static let informant = Level(id: "Informant", imageName: "informant", requirement: "Post 25 spots with at least 100 saves, and get 10 stamps", description: "You are street connected.\n People go to you for information", spots: 25, stamps: 10, saves: 100, friends: 0, cities: 0, mission: 0, trails: 0)
    private static let scout = Level(id: "Scout", imageName: "compass", requirement: "Post 50 spots for at least 250 saves, and get 50 stamps", description: "Scouts are foragers of spots.\nThey are the backbone of CityXcape", spots: 50, stamps: 50, saves: 250, friends: 0, cities: 0, mission: 0, trails: 0)
    private static let recon = Level(id: "Recon", imageName: "recon", requirement: "Post 100 spots for 1,000 saves, get 100 stamps across at least 3 cities", description: "An expert at finding new spots", spots: 100, stamps: 100, saves: 1000, friends: 0, cities: 3, mission: 0, trails: 0)
    private static let forceRecon = Level(id: "Force Recon", imageName: "force_recon", requirement: "Post 300 Spots with a min of 3,000 saves, Get 250 stamps across 20 cities", description: "You verify spots no one else will", spots: 300, stamps: 300, saves: 5000, friends: 0, cities: 20, mission: 0, trails: 0)
    private static let double07 = Level(id: "007", imageName: "007", requirement: "1,000 spots, 10,000 saves, 1,000 stamps across 100 cities", description: "You are a chief scout", spots: 1000, stamps: 1000, saves: 10000, friends: 0, cities: 100, mission: 0, trails: 0)
    
    static let ranks: [Level] = [tourist, visitor, observer, local, informant, scout, recon, forceRecon, double07]
    
    
    
    
    
    // Tourist: 0
    // Visitor: 1 Spot
    // Observer: 3 spots
    // Local: 10 spots, 12 Saves, 3 checkins
    // Informant: 25 spots, 10 checkins, 50 saves
    // Scout: 50 spots, 100 saves, 50 checkins
    // Recon: 100 spots, 500 saves, 100 checkins, 5 cities
    // Force Recon: 300 spots, 1,000 saves, 25 cities
    // 007: 1,000 spots, 10,000 saves, 100 cities
}


