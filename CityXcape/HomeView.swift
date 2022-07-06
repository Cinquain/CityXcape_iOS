//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    let router = Router.shared
    @State var selectedTab: Int = 0
    @StateObject var manager = NotificationsManager.instance
    @StateObject var discoverVM: DiscoverViewModel = DiscoverViewModel()
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.black
        UITabBar.appearance().standardAppearance = tabBarAppearance
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
                .badge(discoverVM.newlySaved)
                .fullScreenCover(isPresented: $manager.showPublicPass, content: {
                    if let verification  = manager.stamp {
                        PublicStampView(verification: verification)
                    }
                })
                .onAppear {
                    discoverVM.newlySaved = 0
                }
            
            
            DiscoverView(selectedTab: $selectedTab, vm: discoverVM)
                    .tabItem {
                        Image(Icon.tabItem0.rawValue)
                            .renderingMode(.template)
                        Text(Labels.tab0.rawValue)
                    }
                    .tag(1)
                    .badge(discoverVM.newSecretSpots.count)
            
    
     
            MapContainer(selectedTab: $selectedTab)
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
        .onReceive(manager.$hasSpotNotification, perform: { bool in
            if bool {
                selectedTab = 1
            }
        })
        .sheet(isPresented: $manager.hasUserNotification) {

        } content: {
            
            if let user = NotificationsManager.instance.user {
                PublicStreetPass(user: user)
            }
            
        }
        .onReceive(router.$link) { deepLink in
            switch deepLink {
            case .home:
                selectedTab = 0
            case .discover:
                selectedTab = 1
            case .streetPass:
                selectedTab = 3
            case .none:
                break
            }
        }
    }
    
    func getAdditionalProfileInfo() {
        guard let uid = userId else {return}
        AuthService.instance.getUserInfo(forUserID: uid) { username, bio, streetcred, profileUrl, social in
            
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
