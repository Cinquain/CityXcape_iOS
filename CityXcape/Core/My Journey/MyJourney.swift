//
//  MyJourney.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct MyJourney: View {
    
    
    let spots: [SecretSpot] = [
        SecretSpot(name: "The Big Duck", imageUrl: "donut", distance: 0.5),
        SecretSpot(name: "Graffiti Pier", imageUrl: "donut", distance: 2),
        SecretSpot(name: "Donut Pub", imageUrl: "donut", distance: 10)
    ]
    @State private var isPresented: Bool = false
    @State private var currentSpot: SecretSpot?
    
    var body: some View {
        
        
        GeometryReader { geo in
            ZStack {
                Color("Background")
                VStack {
                    Ticker()
                        .padding(.top, geo.size.width / 8)
                        .frame(height: 150)
                    
                    SpotRowHeader()
               
                        List {
                            ForEach(spots, id: \.self) { spot in
                                SpotRowView(imageUrl: spot.imageUrl, name: spot.name, distance: spot.distance)
                                    .onTapGesture {
                                        self.currentSpot = spot
                                        isPresented.toggle()
                                    }
                            }
                        }
                        .listStyle(PlainListStyle())
                }
                    
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isPresented, content: {
            ZStack {
                Color.black
                Text(currentSpot?.name ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                isPresented.toggle()
                
            }
        })
        
    }
}

struct MyJourney_Previews: PreviewProvider {
    static var previews: some View {
        MyJourney()
            .colorScheme(.dark)
    }
}
