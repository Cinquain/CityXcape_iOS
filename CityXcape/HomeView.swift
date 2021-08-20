//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
       
        TabView {
    
                MyJourney()
                .tabItem {
                    Image(AppIcon.tabItemI.rawValue)
                        .renderingMode(.template)
                    Text(AppLabels.tab1.rawValue)
                }
            
            MapView()
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                    Image(AppIcon.tabItemII.rawValue)
                        .renderingMode(.template)
                    Text(AppLabels.tab2.rawValue)
                }
            
            Color.blue.edgesIgnoringSafeArea(.all)
                .tabItem {
                    Image(AppIcon.tabItemIII.rawValue)
                        .renderingMode(.template)
                    Text(AppLabels.tab2.rawValue)
                }
                
        }
        .accentColor(.accent)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .colorScheme(.dark)
    }
}
