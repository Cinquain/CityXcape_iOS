//
//  MyJourney.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI
import CoreLocation
import Combine

struct MyJourney: View {
    
    
    private var cancellables = Set<AnyCancellable>()
    @ObservedObject var vm = JourneyViewModel()
  
    @State private var currentIndex = 0
    @State private var isPresented: Bool = false
    @State var currentSpot: SecretSpot? {
        didSet {
            isPresented.toggle()
        }
    }
    
    var body: some View {
        
        let captions: [String] = [
            "CityXcape",
            "\(vm.secretspots.count) Spots to Visit",
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
                            ForEach(vm.secretspots, id: \.self) { spot in
                                
                                SpotRowView(imageUrl: spot.imageUrl, name: spot.spotName, distance: spot.distanceFromUser)
                                    .onTapGesture(perform: {
                                        guard let index = self.vm.secretspots.firstIndex(of: spot) else {return}
                                        self.currentIndex = index
                                        self.isPresented.toggle()
                                    })
                            }
                            
                        }
                        .listStyle(PlainListStyle())
                        .colorScheme(.dark)

                }
                    
            }
        }
        .sheet(isPresented: $isPresented, content: {
            
            SpotDetailsView(spot: vm.secretspots[currentIndex])
            
        })
     
    }
 
  
}

struct MyJourney_Previews: PreviewProvider {
    static var previews: some View {
        MyJourney()
    }
}
