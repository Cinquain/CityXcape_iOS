//
//  MessagePreview.swift
//  CityXcape
//
//  Created by James Allan on 8/24/22.
//

import SwiftUI

struct MessagePreview: View {
    var message: RecentMessage
    
    var body: some View {
        
        HStack(spacing: 20) {
            VStack(spacing: 0) {
                UserDotView(imageUrl: message.profileUrl, width: 50)
                Text(message.displayName)
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading) {
                Text(message.content)
                    .fontWeight(.thin)
                Text("Sent \(message.date.timeAgo())")
                    .font(.caption)
                    .fontWeight(.thin)
            }
            .foregroundColor(.white)
            
            Spacer()
            
            VStack(spacing: 0) {
                Image(message.rank)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text(message.rank)
                    .fontWeight(.thin)
                    .font(.caption)
            }
            .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .background(Color.black)
    }
}

struct MessagePreview_Previews: PreviewProvider {

    static var previews: some View {
        let data: [String:Any] = [
            MessageField.id: "abc123",
            MessageField.toId: "xgfui",
            MessageField.fromId: "ffhfj",
            MessageField.userId: "fjhghgh",
            MessageField.content: "How are you dear mama",
            MessageField.bio: "Scout Life",
            MessageField.rank: "Scout",
            MessageField.timestamp: Date(),
            MessageField.displayName: "Cinquain",
            MessageField.profileUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=1a4c018a-d539-4c95-87ca-fdec61f8e73c"
        ]
        let message: RecentMessage = RecentMessage(data: data)

        MessagePreview(message: message)
    }
}
