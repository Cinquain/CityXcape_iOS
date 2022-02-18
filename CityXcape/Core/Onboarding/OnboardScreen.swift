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
                
            Onboarding(imageName: "fire", description: "CityXcape lets you save places to visit", width: 100, height: 100, lastScreen: false)
            
            Onboarding(imageName: "pin_blue", description: "Save spots you find \n or discover from others", width: 100, height: 100, lastScreen: false)
           
              
                Onboarding(imageName: "Scout", description: "Your job as a scout is to explore ", width: 200, height: 100, lastScreen: true)
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
