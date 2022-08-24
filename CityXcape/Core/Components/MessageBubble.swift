//
//  MessageBubble.swift
//  CityXcape
//
//  Created by James Allan on 8/20/22.
//

import SwiftUI

struct MessageBubble: View {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    
    var message: Message
    var body: some View {
        VStack {
            if message.fromId == userId ?? "" {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.content)
                            .foregroundColor(.cx_orange)
                    }
                    .padding()
                    .background(Color.dark_grey)
                    .cornerRadius(8)
                }
               
            } else {
                HStack {
                    HStack {
                        Text(message.content)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.cx_orange)
                    .cornerRadius(8)
                    Spacer()
                }
            }
        
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct MessageBubble_Previews: PreviewProvider {
 
    static var previews: some View {
        let data: [String: Any] = [
            "id": "fhdbvfhf",
            "fromId": "fjhgjgjhgg",
            "toId": "fggihgg",
            "date": Date(),
            "content": "Hello World James Allana"
        ]
        MessageBubble(message: Message(data: data))
            .previewLayout(.sizeThatFits)
    }
}
