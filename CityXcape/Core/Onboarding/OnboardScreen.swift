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
            TabView {
                
                  OnboardingI()
                    
                  OnboardingII()
                    
                  OnboardingIII()
                
                Onboarding(imageName: Icon.pin.rawValue, description: "Start Saving Locations", width: 150, height: 150, lastScreen: true)
                    .onTapGesture(perform: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    
                        
            }
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .edgesIgnoringSafeArea(.all)
    }

}

struct OnboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardScreen()
    }
}
