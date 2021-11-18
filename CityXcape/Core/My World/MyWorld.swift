//
//  MyJourney.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI
import CoreLocation
import Combine
import Shimmer

struct MyWorld: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var username: String?

    @StateObject var vm = MyWorldViewModel()
  
    @State private var currentIndex = 0
    @State private var isPresented: Bool = false
    @Binding var selectedTab: Int

    
    var body: some View {
        
        let captions: [String] = [
            "CityXcape",
            "\(vm.secretspots.count) Spots to Visit",
            "\(username ?? "")'s World"
        ]
        
            GeometryReader { geo in
                
                ZStack {
                    Color.background
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Ticker(profileUrl: profileUrl ?? "", captions: captions)
                            .frame(height: 150)
                        
                        
                    if vm.showOnboarding {
                        
                        
                        Image("marker")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                        
                        Text("Start building your world by adding \n a spot you want to visit ")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.thin)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            selectedTab = 2
                        } label: {
                            Text("Post a Spot")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                        .foregroundColor(.black)
                        .padding(.top, 40)
                        .shimmering(duration: 4)


                        Spacer()
                    } else {
                        
                        SpotRowHeader()
                   
                            List {
                                ForEach(vm.secretspots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser}), id: \.postId) { spot in
                                    
                                    SpotRowView(imageUrl: spot.imageUrl, name: spot.spotName, distance: spot.distanceFromUser)
                                        .onTapGesture(perform: {
                                            guard let index = self.vm.secretspots.firstIndex(of: spot) else {return}
                                            self.currentIndex = index
                                            isPresented.toggle()
                                        })
                                }
                                
                            }
                            .listStyle(PlainListStyle())
                            .colorScheme(.dark)
                        
                    }
                        
                        
                        
                    }
                        
                }
            }
            .sheet(isPresented: $isPresented, onDismiss: {
                currentIndex = 0
            } ,content: {
        
                if let spot = vm.secretspots[currentIndex] {
                    SpotDetailsView(spot: spot, index: $currentIndex)
                }
                
            })
        
        
      
     
    }
 
  
}

struct MyJourney_Previews: PreviewProvider {
    @State static var selection: Int = 0

    static var previews: some View {
        MyWorld(selectedTab: $selection)
    }
}
