//
//  MessageView.swift
//  CityXcape
//
//  Created by James Allan on 1/28/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    
    @State var comment: Comment
    @State private var showStreetPass: Bool = false
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .center, spacing: 0) {
                Button {
                    showStreetPass.toggle()
                    AnalyticsService.instance.viewStreetpass()
                } label: {
                    UserDotView(imageUrl: comment.imageUrl, width: 40)
                }
                
                Text(comment.username)
                    .font(.caption)
                    .foregroundColor(.gray)
                
            
            }
            
            Text(comment.content)
                .padding(15)
                .background(Color.black)
                .cornerRadius(10)
            
            
            Spacer(minLength: 0)
            
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .sheet(isPresented: $showStreetPass) {
            let user = User(comment: comment)
            PublicStreetPass(user: user)
        }
        

    }
}

struct MessageView_Previews: PreviewProvider {
    
    static var comment: Comment = Comment(id: "abc123", uid: "xyz456", username: "Cinquain", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", bio: "Yolo", content: "This is my best comment ever!", dateCreated: Date())
    
    static var previews: some View {
        MessageView(comment: comment)
            .previewLayout(.sizeThatFits)
            
    }
}
