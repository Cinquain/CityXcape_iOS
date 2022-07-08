//
//  MissionsView.swift
//  CityXcape
//
//  Created by James Allan on 10/2/21.
//

import SwiftUI

struct DiscoverView: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @State private var isPresented: Bool = false
    @State private var currentSpot: SecretSpot?
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var passed: Bool = false
    @State private var saved: Bool = false

    let manager = CoreDataManager.instance
    @Binding var selectedTab: Int
    
    @StateObject var vm: DiscoverViewModel 
   
    
    var body: some View {
 
        NavigationView {
          
    
            ScrollView {
                
                    
                if vm.newSecretSpots.isEmpty {
                         VStack {
                               emptyStateIcon
                               refreshButton
                         }
                                 
                 } else {
                
                ForEach(vm.newSecretSpots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser})) { spot in

                        ZStack {
                          
                            CardView(showAlert: $vm.showAlert, alertMessage: $vm.alertMessage, spot: spot)
                                .animation(Animation.linear(duration: 0.4))

                            
                            VStack(alignment: .center) {
                                LikeAnimationView(color: .cx_green, didLike: $vm.passed, size: 200)
                                   
                                    .animation(Animation.linear(duration: 0.5))
                                
                                Text(" - \(currentSpot?.price ?? 1) StreetCred")
                                    .font(.title)
                                    .fontWeight(.thin)
                                    .foregroundColor(.red)
                            }
                            .opacity(currentSpot == spot && vm.saved ? 1 : 0)
                                
                            passAnimation
                                .opacity(currentSpot == spot && vm.passed ? 1 : 0)
                                .animation(Animation.linear(duration: 0.5))
                        }
                        
                        HStack {
                            Button {
                                //TBD
                                currentSpot = spot
                                vm.passed = true
                                vm.dismissCard(spot: spot)
                            } label: {
                                VStack {
                                    Image(systemName: "hand.thumbsdown")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.stamp_red)
                                        .frame(height: 30)

                                    Text("pass")
                                        .font(.caption)
                                        .foregroundColor(.stamp_red)
                                }

                            }
                            
                            Spacer()
                            
                            Button {
                                //TBD
                                currentSpot = spot
                                vm.saved = true
                                vm.saveCardToUserWorld(spot: spot)
                            } label: {
                                VStack {
                                    Image(systemName: "heart")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.cx_green)
                                        .frame(height: 30)
                                    
                                    Text("save")
                                        .font(.caption)
                                        .foregroundColor(.cx_green)
                                }
                            }


                        }
                        .padding(.horizontal, 20)
                        
              
                        
                        Divider()
                            .frame(height: 0.5)
                            .background(Color.white)
                            .padding(.bottom, 10)

                    }
                    
                             }

                
               
            }
            .navigationBarItems(trailing: searchButton)
            .toolbar {
               ToolbarItem(placement: .principal) {
                   ZStack {
                       
                       Ticker(searchText: $vm.searchTerm, handlesearch: {
                           vm.performSearch()
                       }, width: UIScreen.screenWidth  )
                       .frame(width: UIScreen.screenWidth / 2 )
                       .opacity(vm.isSearching ? 1 : 0)

                       tabIcon
                           .opacity(vm.isSearching ? 0 : 1)
                   }
                   
               }
            }

            
        }
        .colorScheme(.dark)
        .foregroundColor(.white)
        .alert(isPresented: $vm.showAlert) {
            return Alert(title: Text(vm.alertMessage))
        }
        
    }

}

extension DiscoverView {
    
    private var passAnimation: some View {
        Image(systemName: "hand.thumbsdown.fill")
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .foregroundColor(.stamp_red)
    }
    
    private var searchButton: some View {
        
        Button {
            vm.isSearching.toggle()
        } label: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
        }
        .opacity(vm.isSearching ? 0 : 1)
    }
    
    private var refreshButton: some View {
        Button {
            vm.refreshSecretSpots()
            AnalyticsService.instance.loadedNewSpots()
        } label: {
                Text("Refresh")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 120, height: 40)
                    .background(Color.white)
                    .foregroundColor(.cx_blue)
                    .cornerRadius(20)
    }

    }
    
    private var tabIcon: some View {
        VStack(spacing: 0) {
            Image("logo")
                .resizable()
                .scaledToFit()
            .frame(height: 25)
            Text("Save Spots to Visit")
                .fontWeight(.thin)
                .foregroundColor(.white)
                .font(.caption)
        }
    }
    
    private var emptyStateIcon: some View {
        VStack {
            Image("404")
                .resizable()
                .scaledToFit()
            .frame(height: 200)
            Text("No Secret Spot Found")
                .font(.title2)
                .fontWeight(.thin)
        }
       
    }
    
    
}


struct MissionsView_Previews: PreviewProvider {
    @State static var selection: Int = 0
    static var previews: some View {
        DiscoverView(selectedTab: $selection, vm: DiscoverViewModel())
    }
}
