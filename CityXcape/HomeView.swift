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
    @State var showSideMenu: Bool = false
    @StateObject var manager = NotificationsManager.instance
    @StateObject var discoverVM: DiscoverViewModel = DiscoverViewModel()
    @StateObject var feedVM: FeedViewModel = FeedViewModel()
    @StateObject var streetPassVM: StreetPassViewModel = StreetPassViewModel()


    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.black
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
    
    var body: some View {
       
        TabView(selection: $selectedTab) {
            
                   
            DiscoverView(selectedTab: $selectedTab, vm: discoverVM)
                .tabItem {
                    Image(Icon.tabItem0.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab2.rawValue)
                }
                .tag(0)
                .badge(discoverVM.newSecretSpots.count)
            
            MyWorld(selectedTab: $selectedTab)
            .tabItem {
                Image(Icon.tabItemI.rawValue)
                    .renderingMode(.template)
                Text(Labels.tab1.rawValue)
            }
            .tag(1)
            .badge(discoverVM.newlySaved)
            
            
            FeedView(selectedTab: $selectedTab, discoverVM: discoverVM, vm: feedVM)
                .tabItem {
                    Image(Icon.grid.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab0.rawValue)
                }
                .tag(2)
                .badge(feedVM.newFeeds)
                .onAppear {
                    feedVM.newFeeds = 0
                }
                .fullScreenCover(item: $manager.stamp, content: { verification in
                    PublicStampView(verification: verification)
                })
            
                        
            MapContainer(selectedTab: $selectedTab)
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Image(Icon.tabItemII.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab3.rawValue)
                }
                .tag(3)
                .fullScreenCover(item: $manager.world) { world in
                    WorldInviteView(world: world)
                }
            
            
            StreetPass(vm: streetPassVM)
                .tabItem {
                    Image(Icon.tabItemIII.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab4.rawValue)
                }
                .tag(4)
                .badge(streetPassVM.count)
                
        }
        .sheet(item: $manager.user) { user in
            PublicStreetPass(user: user)
        }
        .accentColor(.orange)
        .fullScreenCover(item: $manager.secretSpot) { spot in
            SecretSpotPage(spot: spot, vm: discoverVM)
        }
        .onAppear(perform: {
            
        })
        .colorScheme(.dark)
        .onReceive(router.$link) { deepLink in
            switch deepLink {
            case .home:
                selectedTab = 0
            case .discover:
                selectedTab = 1
            case .streetPass:
                selectedTab = 4
            case .none:
                break
            }
        }
    }
    
    func getAdditionalProfileInfo() {
        guard let uid = userId else {return}
        
        AuthService.instance.getUserInfo(forUserID: uid) { result in
            switch result {
            case .failure(let error):
                print("Error retrieving user info", error)
            case .success(let user):
                let streetcred = user.streetCred ?? 12
                UserDefaults.standard.set(streetcred, forKey: CurrentUserDefaults.wallet)
            }
        }
      
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
