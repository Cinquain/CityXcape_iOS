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
    @State private var showMission: Bool = false

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
                        
                        Text("Start building your world by saving \n spots you want to visit ")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.thin)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            selectedTab = 1
                        } label: {
                            Text("Post a Spot")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .shimmering(duration: 4)


                        Spacer()
                    } else {
                        
                        Picker("Picker", selection: $vm.showVisited) {
                            Text("To Visit")
                                .tag(false)
                                .foregroundColor(.white)
                            
                            Text("Visited")
                                .tag(true)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .foregroundColor(.cx_orange)
                        .colorScheme(.dark)
                        .padding()
                        
                            ScrollView {
                                VStack(spacing: 25) {
                                    ForEach(vm.currentSpots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser}), id: \.id) { spot in
                                        
                                        VStack {
                                            
                                            PreviewCard(spot: spot)
                                                .onTapGesture(perform: {
                                                    
                                                    self.currentSpot = spot
                                                    AnalyticsService.instance.viewedSecretSpot()
                                                })
                                                .sheet(item: $currentSpot) {
                                                    //Dismiss Code
                                                } content: { spot in
                                                    SpotDetailsView(spot: spot)
                                                }
                                            
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
                
                manager.fetchSecretSpots()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    guard let streetname = username else {return}
                    let count = vm.currentSpots.count
                    let countStatement = "You got \(count) spots to visit"
                    let worldStatement = "\(streetname)'s World"
                    
                    captions[1] = countStatement
                    captions[2] = worldStatement
                }
              
            }
           
    }
    
    fileprivate func getExplorerMessage(spot: SecretSpot) -> String {
        if spot.saveCounts > 1 {
            return "\(spot.saveCounts) Explorers"
        } else {
            return "\(spot.saveCounts) Explorer"
        }
    }
    
    
  
}

struct MyJourney_Previews: PreviewProvider {
    @State static var selection: Int = 0

    static var previews: some View {
        MyWorld(selectedTab: $selection)
    }
}
