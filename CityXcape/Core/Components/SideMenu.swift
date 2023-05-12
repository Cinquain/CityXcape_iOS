//
//  SideMenu.swift
//  CityXcape
//
//  Created by James Allan on 9/29/22.
//

import SwiftUI

struct SideMenu: View {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.incognito) var incognito: Bool?
    @EnvironmentObject var worldVM: WorldViewModel
    
    @State private var showAnalytics: Bool = false
    @State private var showJourney: Bool = false
    @State private var showFriends: Bool = false
    @State private var showMessages: Bool = false
    @State private var createWorld: Bool = false
    @State private var showWorlds: Bool = false
    @State private var showTrails: Bool = false
    
    @Binding var selectedTab: Int
    @Binding var showMenu: Bool
    
    let manager = CoreDataManager.instance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Group {
                Button {
                        showMenu.toggle()
                        selectedTab = 3
                } label: {
                    HStack(spacing: 5) {
                        Image("pin_blue")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                        Text("Post Spot")
                            .font(.title3)
                        .fontWeight(.light)
                    }
                }
                .padding()
                .alert(isPresented: $worldVM.showAlert) {
                    return Alert(title: Text(worldVM.alertMessage))
                }
                
                Button {
                    worldVM.loadUserSecretSpots()
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "pencil.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                        Text("Edit Spots")
                            .font(.title3)
                        .fontWeight(.light)
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $worldVM.showSpots) {
                    TotalView(type: .views, spots: worldVM.secretspots)
                }
                
                Button {
                    showFriends.toggle()
                } label: {
                    HStack(spacing: 5) {
                        Image("dot")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                        Text("Friends")
                            .font(.title3)
                        .fontWeight(.light)
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $showFriends) {
                    FriendsView(vm: ChatLogViewModel())
                }
                
             
                
                Button {
                    worldVM.getFriendRequest()
                } label: {
                    HStack(spacing: 5) {
                       Image(systemName:"person.fill.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                            .foregroundColor(.white)
                         
                           Text("Request")
                                .font(.title2)
                                .fontWeight(.thin)
                                .foregroundColor(.white)
                        
                        }
                }
                .padding()
                .fullScreenCover(isPresented: $worldVM.showFriendRequest) {
                    RequestList(friends: worldVM.friendRequest)
                }
                
        
              
           
                
           
                
            }
            
            

            Group {
                
            
                
                
                Button {
                    worldVM.fetchWorldInvitations()
                } label: {
                    HStack(spacing: 5) {
                       Image(systemName:"envelope")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                         
                           Text("Invitations")
                                .font(.title2)
                                .fontWeight(.thin)
                    }
                    .padding()
                }
                .sheet(isPresented: $worldVM.showInvite) {
                    WorldInvitationView(vm: worldVM)
                }
            
                
             
                
                //                Button {
                //                    showTrails.toggle()
                //                } label: {
                //                    HStack {
                //                        Image("trail")
                //                            .resizable()
                //                            .scaledToFit()
                //                            .frame(height: 20)
                //                        Text("Find Trails")
                //                            .font(.title3)
                //                            .fontWeight(.light)
                //                    }
                //                    .padding()
                //                }
                //                .fullScreenCover(isPresented: $showTrails) {
                //                    MyTrailsView()
                //                }

                
//                Button {
//                    worldVM.fetchWorlds()
//                    showWorlds.toggle()
//                } label: {
//                    HStack(spacing: 5) {
//                       Image(systemName:"globe")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 22)
//                            .foregroundColor(.white)
//
//                           Text("Worlds")
//                                .font(.title2)
//                                .fontWeight(.thin)
//                                .foregroundColor(.white)
//
//                        }
//                }
//                .padding()
//                .fullScreenCover(isPresented: $showWorlds) {
//                    DiscoverWorlds(vm: worldVM)
//                }
                
                Button {
                    worldVM.fetchUsersFromWorld()
                } label: {
                    HStack(spacing: 5) {
                        Image("grid")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                        Text("Heatmap")
                            .font(.title3)
                        .fontWeight(.light)
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $worldVM.showHeatmap) {
                    HeatMap(vm: worldVM)
                        .colorScheme(.dark)
                }
                
                
            }
          
            
            
          
    
            
   
            
            
     
            
         
            
            Divider()
                .frame(height: 1)
                .background(.white)
                .padding(.horizontal, 10)
            
            Spacer()
                .onTapGesture {
                    showMenu.toggle()
                }
        }
        .frame(width: 200)
        .background(.black)
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SideMenu_Previews: PreviewProvider {
    @State static var number: Int = 0
    @State static var isOpen: Bool = true

    static var previews: some View {
        SideMenu(selectedTab: $number, showMenu: $isOpen)
            .environmentObject(WorldViewModel())
    }
}
