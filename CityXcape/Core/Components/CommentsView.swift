//
//  CommentsView.swift
//  CityXcape
//
//  Created by James Allan on 1/28/22.
//

import SwiftUI

struct CommentsView: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @State var spot: SecretSpot
    @StateObject var vm: SpotViewModel
    
  
    
    var body: some View {
        VStack {
            
            VStack() {
                HStack {
                    SecretSpotView(width: 80, height: 80, imageUrl: spot.imageUrls.first ?? "")
                    Text(getMessage())
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                
                Divider()
                    .frame(height: 0.5)
                    .background(Color.white)
            
            ScrollView {
                
                ForEach(vm.comments) { comment in
                    MessageView(comment: comment)
                }
            }
            
            HStack {
                UserDotView(imageUrl: profileUrl ?? "", width: 30, height: 30)
                   
                TextField("Add comment", text: $vm.submissionText)
                    .placeholder(when: vm.submissionText.isEmpty) {
                        Text("Add comment").foregroundColor(.gray)
                }
                .padding()
                
                
                Button {
                    //TBD
                    if vm.isTextAppropriate() {
                        vm.uploadComment(postId: spot.id)
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                }

            }
            .padding(.horizontal, 10)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
        
 
    
}
    
    fileprivate func getMessage() -> String {
        if vm.comments.count <= 1 {
            return "\(vm.comments.count) Comment on \(spot.spotName)"
        } else {
            return "\(vm.comments.count) Comments about \(spot.spotName)"
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let spot = SecretSpot(postId: "disnf", spotName: "The Magic Garden", imageUrls: ["https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F3rD6bKzwCbOEpfU51sYF%2F1?alt=media&token=2c45942e-5a44-4dd1-aa83-a678bb848c4b","https://cdn10.phillymag.com/wp-content/uploads/sites/3/2018/07/Emily-Smith-Cory-J-Popp-900x600.jpg", "https://apricotabroaddotco.files.wordpress.com/2019/03/philadelphia-magic-gardens.jpg"], longitude: 1010, latitude: 01202, address: "1229 Spann avenue", description: "This is the best secret spot in the world. Learn all about fractal mathematics", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), price: 1, viewCount: 1, saveCounts: 1, isPublic: true, ownerId: "q4SALDGpjtZLIVtVibHMQa8NpwD3", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", likeCount: 10, didLike: true)
        
        CommentsView(spot: spot, vm: SpotViewModel())
    }
}
