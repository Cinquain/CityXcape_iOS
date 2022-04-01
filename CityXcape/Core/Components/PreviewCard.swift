//
//  PreviewCard.swift
//  CityXcape
//
//  Created by James Allan on 1/4/22.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct PreviewCard: View {
    
    @State var spot: SecretSpot
    
    var body: some View {
        VStack {
            
            WebImage(url: URL(string: spot.imageUrls.first ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .infinity)
                .overlay(
                    ZStack {
                        LinearGradient(colors: [Color.clear, Color.black], startPoint: .center, endPoint: .bottom)
                        
                        if spot.verified {
                            
                            Image("Stamp")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150)
                                .overlay(
                                        Text(spot.spotName)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.stamp_red)
                                    .rotationEffect(Angle(degrees: -30))
                                    )
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                Image("pin_blue")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                Text(spot.spotName)
                                    .font(.title)
                                    .fontWeight(.thin)
                                    .lineLimit(1)
                                Spacer()
                             
                                Text(returnDistance())
                                    .fontWeight(.thin)
                            }.padding(.horizontal, 10)
                            .padding(.bottom, 5)
                        }
                    }
                )
                .cornerRadius(8)
                .clipped()
            
  
        
        }
    }
    
    fileprivate func returnDistance() -> String {
        if spot.distanceFromUser < 1 {
            return String(format: "%.1f mile", spot.distanceFromUser)
        } else {
            return String(format: "%.1f miles", spot.distanceFromUser)
        }
    }
    
    fileprivate func returnSaveCount() -> String {
        if spot.saveCounts <= 1 {
            return "\(spot.saveCounts) save"
        } else {
            return "\(spot.saveCounts) saves"
        }
    }
}

struct PreviewCard_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PreviewCard(spot: SecretSpot.spot)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
