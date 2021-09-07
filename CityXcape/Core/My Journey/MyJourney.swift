//
//  MyJourney.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct MyJourney: View {
    
    
    let spots: [SecretSpot] = [
        SecretSpot(username: "Cinquain", name: "The Big Duck", imageUrl: "big duck", distance: 0.5, address: "3402 avenue I, Brooklyn, NY"),
        SecretSpot(username: "JamesAllan", name: "Graffiti Pier", imageUrl: "graffiti pier", distance: 2, address: "230 Court St, Philly, PA"),
        SecretSpot(username: "IceHistory", name: "Donut Pub", imageUrl: "donut", distance: 10, address: "45 Wall St, NY, NY"),
        SecretSpot(username: "Cinquain", name: "Eicher Home", imageUrl: "Eichler", distance: 5, address: "656 Explorer avenenue"),
        SecretSpot(username: "Cinquain", name: "Ark Encounter", imageUrl: "Ark Encounter", distance: 300, address: "1 Ark Encounter Dr, Williamstown, KY")
    ]
  
    
    @State private var isPresented: Bool = false
    @State var currentSpot: SecretSpot? {
        didSet {
            isPresented.toggle()
        }
    }
    
    var body: some View {
        
        let captions: [String] = [
            "CityXcape",
            "\(spots.count) Spots to Visit",
            "Explore to Meet New People"
        ]
        
        GeometryReader { geo in
            ZStack {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Ticker(captions: captions)
                        .frame(height: 150)
                    
                    SpotRowHeader()
               
                        List {
                            ForEach(spots.sorted(by: {$0.distance < $1.distance}), id: \.self) { spot in
                                
                                SpotRowView(imageUrl: spot.imageUrl, name: spot.name, distance: spot.distance)
                                    .onTapGesture {
                                        self.currentSpot = spot
                                    }
                            }
                            
                        }
                        .listStyle(PlainListStyle())
                        .colorScheme(.dark)

                }
                    
            }
        }
        .sheet(isPresented: $isPresented, content: {
            
            if let spot = currentSpot {
                SpotDetailsView(spot: spot)
            } else {
                Text("No Spot Found")
            }
            
        })
        
    }
}

struct MyJourney_Previews: PreviewProvider {
    static var previews: some View {
        MyJourney()
    }
}
