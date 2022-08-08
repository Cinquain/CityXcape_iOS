//
//  ChatLogView.swift
//  CityXcape
//
//  Created by James Allan on 8/5/22.
//

import SwiftUI

struct ChatLogView: View {
    
    @State var user: User?
    @State private var chatText: String = ""
    var body: some View {
        ZStack {
            messageView
            VStack {
                Spacer()
                chatBottomBar
                    .background(Color.white)
            }
        }
        .navigationTitle("Cinquain")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ChatLogView {
    private var messageView: some View {
        ScrollView {
            ForEach(0..<15) { num in
                HStack {
                    Spacer()
                    HStack {
                        Text("Fake message for for now \(num)")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
            }
           
            HStack{ Spacer() }
            
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    private var chatBottomBar: some View {
        HStack {
            Button {
                //
            } label: {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
            }
            TextField("Description", text: $chatText)
            Button {
                //TBD
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLogView()
    }
}
