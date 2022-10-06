//
//  OnboardingII.swift
//  CityXcape
//
//  Created by James Allan on 9/14/22.
//

import SwiftUI

struct OnboardingII: View {
    let width: CGFloat = UIScreen.screenWidth
    var body: some View {
        VStack {
            
            
            ZStack {
                Rectangle()
                    .fill(.white)
                    .frame(width: width - 20, height: width - 20)
                
                Image("magic_garden")
                    .resizable()
                    .scaledToFill()
                    .frame(width: width - 40, height: width - 40)
                    .clipped()
            }
            
            HStack {
                Spacer()
                Text("Collect stamps by visiting \n the locations you save")
                    .font(.title2)
                    .fontWeight(.thin)
                Spacer()
            }
            .foregroundColor(.white)
            
            
            StampView(spot: SecretSpot.spot)
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

extension OnboardingII {
    private var stamp: some View {
        HStack(alignment: .bottom) {
            Spacer()
            Image("Stamp")
                .resizable()
                .scaledToFit()
                .frame(height: width - 100 )
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        
                        Text(Date().formattedDate())
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.stamp_red)
                        
                        Text("The Magic Garden, \(Date().timeFormatter())")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.stamp_red)

                        
                    
                    }
                    .rotationEffect(Angle(degrees: -30))
                    )
            
      
            
        }
        .padding()
    }
}
struct OnboardingII_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingII()
    }
}
