//
//  CardView.swift
//  CityXcape
//
//  Created by James Allan on 10/8/21.
//

import SwiftUI
import Shimmer
import SDWebImageSwiftUI

struct CardView: View {
    
    @State private var showStreetPass: Bool = false
    var spot: SecretSpot
    let insets = EdgeInsets(top: 20, leading: 5, bottom: 40, trailing: 10)
    
    var body: some View {
        
        VStack(spacing: 0) {
            WebImage(url: URL(string: spot.imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
            
            Divider()
                .background(Color.white)
            
            HStack {
                
                Button {
                    //To be continued
                    showStreetPass.toggle()
                    AnalyticsService.instance.touchedProfile()
                } label: {
                    UserDotView(imageUrl: spot.ownerImageUrl, width: 40, height: 40)
                        .padding(.leading, 20)

                    
                    Text(spot.ownerDisplayName)
                        .font(.subheadline)
                        .fontWeight(.thin)
                }

                
                Spacer()
                Image(systemName: "figure.walk")
                Text(calculateDistance())
                    .fontWeight(.thin)
                    .font(.subheadline)
                    .padding(.trailing, 20)
                    .padding(.leading, -4)
            }
            .padding(.top, 5)
            
            Text(spot.description ?? "")
                .fontWeight(.thin)
                .padding(.horizontal, 40)
                .padding(.top, 20)
                .lineLimit(3)
            Spacer()
            
            HStack(alignment: .top) {
                Image("pin_blue")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                
                Text(spot.spotName)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .font(.title2)
                    .padding(.top, 5)
                
                Spacer()
            }
        }
        .frame(width: 350, height: 500)
        .background(Color.black)
        .cornerRadius(20)
        .foregroundColor(.white)
        .sheet(isPresented: $showStreetPass) {
            //TBD
            
        } content: {
            //TBD
            PublicStreetPass(uid: spot.ownerId, profileUrl: spot.ownerImageUrl, username: spot.ownerDisplayName, userbio: nil, streetCred: nil)
        }

        
      
    }
    
    fileprivate func calculateDistance() -> String {
        let distanceString = String(format: "%.1f", spot.distanceFromUser)
        let distance = spot.distanceFromUser > 1 ? "\(distanceString) miles away" : "\(distanceString) mile away"
        return distance
    }
}

struct CardView_Previews: PreviewProvider {
    static var secretspot = SecretSpot(postId: "1234", spotName: "The Eichler Home", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/missions%2Fexplore.jpg?alt=media&token=474e3d92-bf7a-4ce0-afc9-f996d5f96fd9", longitude: 39.784352, latitude: -86.093180, address: "1229 Spann Ave", city: "Indianapolis", zipcode: 46203, world: "Surfers", dateCreated: Date(), viewCount: 4, price: 1, saveCounts: 30, isPublic: true, description: "This is the best spot in the world", ownerId: "Cinquain", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FhotK4d2IZDYs0wjlKc3A%2FprofileImage?alt=media&token=57e6e26b-ffef-4d31-be3a-db599c4c97a9", spotImageUrls: [""])
    static var previews: some View {
        CardView(spot: secretspot)
    }
}
