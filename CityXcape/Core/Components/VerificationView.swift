//
//  CheckinView.swift
//  CityXcape
//
//  Created by James Allan on 11/28/21.
//

import SwiftUI

struct VerificationView: View {
    
    @Environment(\.presentationMode) var presentationMode

    var spot: SecretSpot
    
    
    var body: some View {
        ZStack {
            AnimationView()
            
            VStack {
                VStack {
                    Text("Congratulations!")
                        .font(.title2)
                        .fontWeight(.thin)

                    Image("pin_blue")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .opacity(0.2)
                    
                    Text("You've verified \(spot.spotName) \n You earned 3 StreetCred")
                        .fontWeight(.thin)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        //Present Sheet
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Dismiss")
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                            .font(.callout)
                    }
                    .frame(width: 200, height: 45)
                    .background(Color.orange.opacity(0.5))
                    .cornerRadius(8)
                    .padding(.top, 30)


                }
                .foregroundColor(.white)

                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct CheckinView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let spot = SecretSpot(postId: "xfhug", spotName: "The Big Duck", imageUrls: ["https://upload.wikimedia.org/wikipedia/commons/2/21/Mandel_zoom_00_mandelbrot_set.jpg"], longitude: 1010, latitude: 01202, address: "1229 Spann avenue", description: "This the best secret spot in the world", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), price: 1, viewCount: 1, saveCounts: 1, isPublic: true, ownerId: "Cinquain", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", likeCount: 10, didLike: true)
        
        VerificationView(spot: spot)
    }
}
