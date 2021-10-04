//
//  Onboarding.swift
//  CityXcape
//
//  Created by James Allan on 9/22/21.
//

import SwiftUI

struct Onboarding: View {
    
    var imageName: String
    var description: String
    var width: CGFloat
    var height: CGFloat
    var lastScreen: Bool
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Spacer()
                .frame(maxWidth: .infinity)

            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
            
            Text(description)
                .lineLimit(3)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            if lastScreen {
                Spacer()
                    .frame(height: 50)
                VStack {
                    Image(systemName: "hand.tap")
                        .font(.title)
                        .foregroundColor(.white)
                        .scaleEffect(self.isAnimating ? 1.5 : 1)
                        .animation(Animation.linear(duration: 1).repeatForever())
                        .onAppear(perform: {
                            self.isAnimating = true
                        })
                        .padding()
                    Text("Tap to dismiss")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .scaleEffect(isAnimating ? 1.2 : 1)
                        .animation(.linear(duration: 1).repeatForever())
                }
            }
         
       
            Spacer()
                .frame(maxWidth: .infinity)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        
        Onboarding(imageName: "pin_blue", description: "Secret Spots are cool places \n unknown to most people", width: 100, height: 100, lastScreen: false)
        
    }
}
