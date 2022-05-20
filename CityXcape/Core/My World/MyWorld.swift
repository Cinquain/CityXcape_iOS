//
//  MyJourney.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI
import CoreLocation
import Combine

struct MyWorld: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var username: String?

    @StateObject var vm = MyWorldViewModel()
    @State private var isPresented: Bool = false
    @Binding var selectedTab: Int
    @State var currentSpot: SecretSpot?
    @State private var showMission: Bool = false
    @State var searchTerm: String = ""


    let manager = CoreDataManager.instance

    var body: some View {
        
   
            VStack {
                
                Ticker(searchText: $searchTerm, handlesearch: {
                        vm.performSearch(searchTerm: searchTerm)
                    })
                        
                        
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
                            Text("Find Spots")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                        .foregroundColor(.white)
                        .padding(.top, 40)


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
                    .background(Color.background.edgesIgnoringSafeArea(.all))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            vm.fetchSecretSpots()
                        }
                    }
                   
            
        
        //End of body
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
