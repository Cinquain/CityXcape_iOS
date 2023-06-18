//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct HomeView: View {
    
    
    let router = Router.shared
    @State var selectedTab: Int = 0
    @State var showSideMenu: Bool = false
    

    @StateObject var notifManager = NotificationsManager.instance
    
    @ObservedObject var streetPassVM: StreetPassViewModel = StreetPassViewModel()
    @ObservedObject var worldVM: WorldViewModel = WorldViewModel()
    @ObservedObject var myWorld: MyWorldViewModel = MyWorldViewModel()
    @ObservedObject var discoverVM: DiscoverViewModel = DiscoverViewModel()
    @ObservedObject var feedVM: FeedViewModel = FeedViewModel()

    

    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.black
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
    
    var body: some View {
            
            TabView(selection: $selectedTab) {
                
                       
                DiscoverView(vm: discoverVM,
                             worldVM: worldVM,
                             selectedTab: $selectedTab)
                    .tabItem {
                        Image(Icon.tabItem0.rawValue)
                            .renderingMode(.template)
                        Text(Labels.tab2.rawValue)
                    }
                    .tag(0)
                    .badge(discoverVM.newSpotCount)
                
                
                MyWorld(worldVM: worldVM,
                        vm: myWorld,
                        selectedTab: $selectedTab)
                .tabItem {
                    Image(Icon.tabItemI.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab1.rawValue)
                }
                .tag(1)
                .badge(discoverVM.newlySaved)
            
                
                FeedView(vm: feedVM,
                         discoverVM: discoverVM,
                         worldVM: worldVM,
                         selectedTab: $selectedTab)
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
                    .fullScreenCover(item: $notifManager.stamp, content: { verification in
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
                    .fullScreenCover(item: $notifManager.world) { world in
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
            .sheet(item: $notifManager.user) { user in
                PublicStreetPass(user: user)
            }
            .accentColor(.orange)
            .fullScreenCover(item: $notifManager.secretSpot) { spot in
                SecretSpotPage(vm: discoverVM, spot: spot)
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
        
    }

    
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
