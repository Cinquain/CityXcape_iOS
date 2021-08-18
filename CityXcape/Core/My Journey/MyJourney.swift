//
//  MyJourney.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct MyJourney: View {
    
    let picture = Image("donut")
    @State private var spotNumber: Int = 0
    let spots = [
        "The Big Duck",
        "Graffit Pier",
        "Donut Pub"
    ]
    
    @State private var isPresented: Bool = false
    
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
                            ForEach(1...10, id: \.self) { spot in
                                SpotRowView(image: picture, name: "Donut Pub", distance: 0.5)
                                    .onTapGesture {
                                        spotNumber = spot
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
                Text("Spot \(spotNumber)")
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
