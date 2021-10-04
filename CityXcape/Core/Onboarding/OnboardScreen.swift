//
//  OnboardScreen.swift
//  CityXcape
//
//  Created by James Allan on 9/22/21.
//

import SwiftUI

struct OnboardScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            TabView {
                
                Onboarding(imageName: "fire", description: "CityXcape is an app to find \n and share Secret Spots", width: 100, height: 100, lastScreen: false)
                
                Onboarding(imageName: "pin_blue", description: "Secret Spots are cool places \n not known by most people", width: 100, height: 100, lastScreen: false)
                
                Onboarding(imageName: "locked", description: "Secret Spots are kept hidden by \n being visible only to a world", width: 100, height: 100, lastScreen: false)
                
                Onboarding(imageName: "globe", description: "Worlds are communities who \n share secret spots. Examples of worlds are \n #Urbex, #Surfers, #Skaters, #LGBT, etc.", width: 100, height: 100, lastScreen: false)
    
              
                Onboarding(imageName: "Scout", description: "Your job as a scout is to find \n secret spots for one or more world", width: 200, height: 100, lastScreen: true)
                    .onTapGesture(perform: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                
            }
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
        }
        .edgesIgnoringSafeArea(.all)
    }

}

struct OnboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardScreen()
    }
}
