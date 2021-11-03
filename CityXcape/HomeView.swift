//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    
    @State var selectedTab: Int = 0
    @StateObject var manager = NotificationsManager.instance
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .black
    }
    
    var body: some View {
       
        TabView(selection: $selectedTab) {
    
                MyWorld(selectedTab: $selectedTab)
                .tabItem {
                    Image(Icon.tabItemI.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab1.rawValue)
                }
                .tag(0)
            
            MissionsView(selectedTab: $selectedTab)
                    .tabItem {
                        Image(Icon.tabItem0.rawValue)
                            .renderingMode(.template)
                        Text(Labels.tab0.rawValue)
                    }
                    .tag(1)
            
            MapContainer(isMission: false)
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Image(Icon.tabItemII.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab2.rawValue)
                }
                .tag(2)
            
            StreetPass()
                .tabItem {
                    Image(Icon.tabItemIII.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab3.rawValue)
                }
                .tag(3)
                
        }
        .accentColor(.orange)
        .onAppear(perform: {
            
        })
        .colorScheme(.dark)
        .sheet(isPresented: $manager.hasNotification) {

        } content: {
            PublicStreetPass(profileUrl: manager.userImageUrl,
                             username: manager.username,
                             userbio: manager.userBio,
                             streetCred: manager.streetcred)
        }

        
    }
    
    func getAdditionalProfileInfo() {
        guard let uid = userId else {return}
        AuthService.instance.getUserInfo(forUserID: uid) { username, bio, streetcred, profileUrl in
            
            if let streetCred = streetcred {
                UserDefaults.standard.set(streetCred, forKey: CurrentUserDefaults.wallet)

            }
            
            
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
