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
import JGProgressHUD_SwiftUI

struct MyWorld: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var username: String?

    @StateObject var vm = MyWorldViewModel()
    
    @State private var isPresented: Bool = false
    @Binding var selectedTab: Int
    @State var currentSpot: SecretSpot?
    @State var currentList: SecretSpot?

    let manager = CoreDataManager.instance
    @State var captions: [String] = [
        "CityXcape",
        "You got Spots to Visit",
        "Your World"
    ]
    
    var body: some View {
        
   
        
            GeometryReader { geo in
                
                ZStack {
                    Color.background
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Ticker(profileUrl: profileUrl ?? "", captions: $captions)
                            .frame(height: 100)
                        
                        
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
                            ScrollView {
                                VStack(spacing: 25) {
                                    ForEach(vm.secretspots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser}), id: \.id) { spot in
                                        
                                        VStack {
                                            
                                            PreviewCard(spot: spot)
                                                .onTapGesture(perform: {
                                                    self.currentSpot = spot
                                                })
                                                .sheet(item: $currentSpot) {
                                                    //Dismiss Code
                                                } content: { spot in
                                                    SpotDetailsView(spot: spot)
                                                }
                                            
                                            //Action Buttons
                                            HStack {
                                                Button {
                                                    vm.openGoogleMap(spot: spot)
                                                } label: {
                                                    Image("walking")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(height: 20)
                                                    Text("\(spot.distanceFromUser) miles")
                                                        .fontWeight(.thin)
                                                }

                                                Spacer()
                                                
                                                Button {
                                                    //TBD
                                                    self.currentList = spot
                                                    vm.getSavedbyUsers(postId: spot.id)
                                                } label: {
                                                   
                                                   Image("dot")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 30, height: 30)
                                                    
                                                    Text("\(spot.saveCounts) Explorers")
                                                        .fontWeight(.thin)
                                        
                                                }
                                                .sheet(item: $currentList) {
                                                    //TBD
                                                    manager.fetchSecretSpots()
                                                } content: { spot in
                                                    SavesView(spot: spot, vm: vm)
                                                }

                                            
                                                
                                                //End of HStack
                                            }
                                            .padding(.horizontal, 10)
                                        }
                                        
                                     //End of VStack
                                        Divider()
                                    }
                                }
                                
                            }
                            .colorScheme(.dark)
                        
                    }
                        
                        
                        
                    }
                        
                }
            }
            .onAppear {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    guard let streetname = username else {return}
                    let count = vm.secretspots.count
                    let countStatement = "You got \(count) spots to visit"
                    let worldStatement = "\(streetname)'s World"
                    
                    captions[1] = countStatement
                    captions[2] = worldStatement
                }
              
            }
     
    }
    
    
  
}

struct MyJourney_Previews: PreviewProvider {
    @State static var selection: Int = 0

    static var previews: some View {
        MyWorld(selectedTab: $selection)
    }
}
