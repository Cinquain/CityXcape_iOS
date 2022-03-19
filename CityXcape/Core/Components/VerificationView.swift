//
//  VerificationView.swift
//  CityXcape
//
//  Created by James Allan on 2/24/22.
//

import SwiftUI

struct VerificationView: View {
    
    var spot: SecretSpot
    var vm: SpotViewModel
    
    @State private var currentUser: User?

    var body: some View {
        
        VStack {
            HStack {
                SecretSpotView(width: 80, height: 80, imageUrl: spot.imageUrls.first ?? "")
                Text(getMessage())
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 15)
            
            Divider()
                .frame(height: 0.5)
                .background(Color.white)
            
            Spacer()
                .frame(height: 40)
            
            ScrollView {
                
                ForEach(vm.users) { user in
                    
                    HStack {
                        Button {
                            //TBD
                            self.currentUser = user
                        } label: {
                            
                            VStack(spacing: 0) {
                                UserDotView(imageUrl: user.profileImageUrl, width: 80, height: 80)
                                Text(user.displayName)
                                    .fontWeight(.thin)
                                    .frame(width: 70)
                                    .lineLimit(1)
                            }
                        }
                        .sheet(item: $currentUser) { user in
                            PublicStreetPass(user: user)
                        }
                        
                        Spacer()
                        
                        Button {
                            //TBD
                        } label: {
                            
                            VStack(spacing: 4) {
                                Image("checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.5)
                                    .frame(width: 35)
                                Text("Verified on \n \(user.verified?.description ?? "")")
                                    .fontWeight(.thin)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.trailing, 10)
                        }


                    }
                    .padding(.horizontal, 12)
                    
                    Divider()
                        .frame(height: 0.3)
                        .background(Color.gray)
                        .padding(.horizontal, 12)
                }
                
            }
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        
    }
    
    fileprivate func getMessage() -> String {
        if vm.users.count <= 1 {
            return "\(vm.users.count) Person verified \(spot.spotName)"
        } else {
            return "\(vm.users.count) People verified \(spot.spotName)"
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        
        let spot = SecretSpot(postId: "disnf", spotName: "The Magic Garden", imageUrls: ["https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F3rD6bKzwCbOEpfU51sYF%2F1?alt=media&token=2c45942e-5a44-4dd1-aa83-a678bb848c4b","https://cdn10.phillymag.com/wp-content/uploads/sites/3/2018/07/Emily-Smith-Cory-J-Popp-900x600.jpg", "https://apricotabroaddotco.files.wordpress.com/2019/03/philadelphia-magic-gardens.jpg"], longitude: 1010, latitude: 01202, address: "1229 Spann avenue", description: "This is the best secret spot in the world. Learn all about fractal mathematics", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), price: 1, viewCount: 1, saveCounts: 10, isPublic: true, ownerId: "q4SALDGpjtZLIVtVibHMQa8NpwD3", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", likeCount: 10, didLike: true, verifierCount: 0)
        
        VerificationView(spot: spot, vm: SpotViewModel())
    }
}
