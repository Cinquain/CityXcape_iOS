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
    private var cancellables = Set<AnyCancellable>()
    @StateObject var vm = MyWorldViewModel()
  
    @State private var currentIndex = 0
    @State private var isPresented: Bool = false

    
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
                        
                        
                    if vm.showOnboarding {
                        
                        
                        Text("Your world consist of spots \n you know or want to vist")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.thin)
                            .multilineTextAlignment(.center)
                        Image("marker")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                        
                        Text("Start building your world \n by adding a Secret Spot ")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.thin)
                        
                        Button {
                            print("Hello World")
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
                    }
                        
                    }
                        
                }
            }
            .sheet(isPresented: $isPresented, onDismiss: {
                currentIndex = 0
            } ,content: {
        
                if let spot = vm.secretspots[currentIndex] {
                    SpotDetailsView(spot: spot)
                }
                
            })
        
        
      
     
    }
 
  
}

struct MyJourney_Previews: PreviewProvider {
    static var previews: some View {
        MyWorld()
    }
}
