//
//  SideMenu.swift
//  CityXcape
//
//  Created by James Allan on 9/29/22.
//

import SwiftUI

struct SideMenu: View {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?

    @State private var showAnalytics: Bool = false
    @State private var showJourney: Bool = false
    @State private var showFriends: Bool = false
    @State private var showMessages: Bool = false
    @State private var createWorld: Bool = false
    @State private var showWorlds: Bool = false
    
    @Binding var selectedTab: Int
    @Binding var showMenu: Bool
    
    let manager = CoreDataManager.instance
    @StateObject var chatVM = ChatLogViewModel()
    @StateObject var worldVM: WorldViewModel = WorldViewModel()
    
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
                
                Button {
                    showFriends.toggle()
                } label: {
                    HStack(spacing: 5) {
                        Image("dot")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                        Text("Message")
                            .font(.title3)
                        .fontWeight(.light)
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $showFriends) {
                    FriendsView(vm: chatVM)
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
                    showJourney.toggle()
                } label: {
                    HStack(spacing: 5) {
                        Image("walking")
                             .resizable()
                             .scaledToFit()
                             .frame(height: 23)
                                                 
                        Text("My Journey")
                             .font(.title3)
                             .fontWeight(.light)
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $showJourney) {
                    JourneyView()
                }
                
                
           
                
            }
            
            

            Group {
                
                Button {
                    showAnalytics.toggle()
                } label: {
                    HStack(spacing: 5) {
                        Image("graph")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                        Text("Analytics")
                            .font(.title3)
                        .fontWeight(.light)
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $showAnalytics) {
                    StreetReportCard()
                }
                
           
                
                Button {
                    worldVM.getFriendRequest()
                } label: {
                    HStack(spacing: 5) {
                       Image(systemName:"person.fill.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                            .foregroundColor(chatVM.count > 0 ? .yellow : .white)
                         
                           Text("Request")
                                .font(.title2)
                                .fontWeight(.thin)
                                .foregroundColor(chatVM.count > 0 ? .yellow : .white)
                        
                        }
                }
                .padding()
                .fullScreenCover(isPresented: $worldVM.showFriendRequest) {
                    RequestList(friends: worldVM.friendRequest)
                }
                
                
                
                
                Button {
                    worldVM.fetchWorldInvitations()
                } label: {
                    HStack(spacing: 5) {
                       Image(systemName:"envelope")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                         
                           Text("Invitations")
                                .font(.title2)
                                .fontWeight(.thin)
                    }
                    .padding()
                }
                .sheet(isPresented: $worldVM.showInvite) {
                    WorldInvitationView(vm: worldVM)
                }
                
                Button {
                    showWorlds.toggle()
                } label: {
                    HStack(spacing: 5) {
                       Image(systemName:"globe")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                            .foregroundColor(chatVM.count > 0 ? .yellow : .white)
                         
                           Text("Communities")
                                .font(.title2)
                                .fontWeight(.thin)
                                .foregroundColor(chatVM.count > 0 ? .yellow : .white)
                        
                        }
                }
                .padding()
                .fullScreenCover(isPresented: $showWorlds) {
                    DiscoverWorlds(vm: worldVM)
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
    }
}
