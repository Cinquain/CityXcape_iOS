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
        
        var spot = SecretSpot(postId: "disnf", spotName: "Graphiti Pier", imageUrls: ["https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F3rD6bKzwCbOEpfU51sYF%2F1?alt=media&token=2c45942e-5a44-4dd1-aa83-a678bb848c4b","https://cdn10.phillymag.com/wp-content/uploads/sites/3/2018/07/Emily-Smith-Cory-J-Popp-900x600.jpg", "https://apricotabroaddotco.files.wordpress.com/2019/03/philadelphia-magic-gardens.jpg"], longitude: 1010, latitude: 01202, address: "1229 Spann avenue", description: "This is the best secret spot in the world. Learn all about fractal mathematics", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), price: 1, viewCount: 1, saveCounts: 2, isPublic: true, ownerId: "q4SALDGpjtZLIVtVibHMQa8NpwD3", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", likeCount: 10, didLike: true, verifierCount: 0)
        PreviewCard(spot: spot)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
