//
//  UserChatView.swift
//  CityXcape
//
//  Created by James Allan on 7/29/22.
//

import SwiftUI

struct UserChatView: View {
    
    var message: Message
    
    @State private var showStreetPass: Bool = false
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            Button {
                showStreetPass.toggle()
            } label: {
                UserDotView(imageUrl: message.user.profileImageUrl, width: 60)
            }
            .sheet(isPresented: $showStreetPass) {
                PublicStreetPass(user: message.user)
            }
              
            
            VStack(alignment: .leading) {
                Text(message.user.displayName)
                    .foregroundColor(.white)
                Text(message.content)
                    .fontWeight(.thin)
            }
            
            Spacer()
            
            Text(message.date.timeAgo())
                .font(.system(size: 14, weight: .semibold))
                .fontWeight(.thin)
        }
        .foregroundColor(.white)
        .background(Color.black)
        
    }
}

struct UserChatView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "gfhjdf", displayName: "Cinquain", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=1a4c018a-d539-4c95-87ca-fdec61f8e73c")
        let message = Message(id: "1234", user: user, date: Date(), content: "Message from user")
        UserChatView(message: message)
            .previewLayout(.sizeThatFits)
    }
}
