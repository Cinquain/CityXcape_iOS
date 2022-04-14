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
                UserDotView(imageUrl: profileUrl ?? "", width: 30)
                   
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
        
        CommentsView(spot: SecretSpot.spot, vm: SpotViewModel())
    }
}
