//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct HomeView: View {
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .black
    }
    
    var body: some View {
       
        TabView {
            
                MissionsView()
                    .tabItem {
                        Image(Icon.tabItem0.rawValue)
                            .renderingMode(.template)
                        Text(Labels.tab0.rawValue)
                    }
                    
    
                MyWorld()
                .tabItem {
                    Image(Icon.tabItemI.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab1.rawValue)
                }
            
            MapContainer()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Image(Icon.tabItemII.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab2.rawValue)
                }
            
            StreetPass()
                .tabItem {
                    Image(Icon.tabItemIII.rawValue)
                        .renderingMode(.template)
                    Text(Labels.tab3.rawValue)
                }
                
        }
        .accentColor(.orange)
        .colorScheme(.dark)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
