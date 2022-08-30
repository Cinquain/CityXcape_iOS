//
//  ChatLogView.swift
//  CityXcape
//
//  Created by James Allan on 8/5/22.
//

import SwiftUI

struct ChatLogView: View {
    
    @State var user: User
    @StateObject var vm: ChatLogViewModel = ChatLogViewModel()
 
    
    var body: some View {
        ZStack {
            messageView
            VStack {
                Spacer()
                chatBottomBar
                    .background(Color.dark_grey)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.fetchMessages(userId: user.id)
            vm.deleteRecentMessage(userId: user.id)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    UserDotView(imageUrl: user.profileImageUrl, width: 35)
                    Text(user.displayName)
                }.foregroundColor(.white)
            }
        }
        
    }
}

extension ChatLogView {
    private var messageView: some View {
        ScrollView {
            ScrollViewReader { proxy in
                ForEach(vm.messages.sorted(by: {$0.date < $1.date})) { message in
                    MessageBubble(message: message)
                }
               
                HStack{ Spacer() }
                    .id(Keys.proxy)
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            proxy.scrollTo(Keys.proxy)
                        }
                    }
            }
        
            
        }
        .background(Color.black)
    }
    
    private var chatBottomBar: some View {
        HStack {
            Button {
            } label: {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 24))
                    .foregroundColor(.cx_orange)
            }
            TextField("Description", text: $vm.message)
                .foregroundColor(.cx_orange)
            Button {
                vm.sendMessage(user: user)
            } label: {
                Text("Send")
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.cx_orange)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLogView(user: User())
    }
}
