//
//  StampView.swift
//  CityXcape
//
//  Created by James Allan on 2/19/22.
//

import SwiftUI

struct StampView: View {
    
    var spot: SecretSpot
    var date = Date.formattedDate(Date())
    var hour = Date.timeFormatter(Date())
    
    @State private var animate: Bool = true
    
    var body: some View {
        
        
        VStack {
            Image("Stamp")
                .resizable()
                .scaledToFit()
                .frame(width: 325)
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        
                        Text("\(spot.spotName)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.stamp_red)
                        
                        Text("\(date())")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.stamp_red)
                        
                        Text("\(hour())")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.stamp_red)
                        
                    }
                    .rotationEffect(Angle(degrees: -32))
                    )
                .rotationEffect(animate ? Angle(degrees: 0) : Angle(degrees: -45))
                .scaleEffect(animate ? 4 : 1)
                .animation(.easeIn(duration: 0.4))
                .animation(.spring())
        }
        .onAppear {
            SoundManager.instance.playSound()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animate = false
            }
            
        }
        
    }
}




struct StampView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let spot = SecretSpot(postId: "disnf", spotName: "The Magic Garden", imageUrls: ["https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F3rD6bKzwCbOEpfU51sYF%2F1?alt=media&token=2c45942e-5a44-4dd1-aa83-a678bb848c4b","https://cdn10.phillymag.com/wp-content/uploads/sites/3/2018/07/Emily-Smith-Cory-J-Popp-900x600.jpg", "https://apricotabroaddotco.files.wordpress.com/2019/03/philadelphia-magic-gardens.jpg"], longitude: 1010, latitude: 01202, address: "1229 Spann avenue", description: "This is the best secret spot in the world. Learn all about fractal mathematics", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), price: 1, viewCount: 1, saveCounts: 1, isPublic: true, ownerId: "q4SALDGpjtZLIVtVibHMQa8NpwD3", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", likeCount: 10, didLike: true)
        
        StampView(spot: spot)
    }
}
