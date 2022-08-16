//
//  UserChatView.swift
//  CityXcape
//
//  Created by James Allan on 7/29/22.
//

import SwiftUI

struct UserChatView: View {
    
    var user: User
    
    @State private var showStreetPass: Bool = false
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            Button {
                showStreetPass.toggle()
            } label: {
                UserDotView(imageUrl: user.profileImageUrl, width: 60)
            }
            .sheet(isPresented: $showStreetPass) {
                PublicStreetPass(user: user)
            }
              
            
            VStack(alignment: .leading) {
                Text(user.displayName)
                    .foregroundColor(.white)
                Text(user.bio ?? "")
                    .fontWeight(.thin)
            }
            
            Spacer()
            
            VStack {
                Image(user.rank ?? "Tourist")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text(user.rank ?? "Tourist")
                    .fontWeight(.thin)
                    .font(.caption)
            }
            .padding(.trailing, 30)
            .foregroundColor(.white)
        }
        .foregroundColor(.white)
        .background(Color.black)
        
    }
}

struct UserChatView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "gfhjdf", displayName: "Cinquain", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=1a4c018a-d539-4c95-87ca-fdec61f8e73c")
        
        UserChatView(user: user)
            .previewLayout(.sizeThatFits)
    }
}
