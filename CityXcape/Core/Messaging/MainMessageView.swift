//
//  MainMessageView.swift
//  CityXcape
//
//  Created by James Allan on 7/28/22.
//

import SwiftUI

struct MainMessageView: View {
    
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: MessageViewModel = MessageViewModel()
   

    var body: some View {
        
        NavigationView {
            VStack {
                
                HStack {
                    UserDotView(imageUrl:profileUrl ?? "", width: 70)
                    userStatus
                    Spacer()
                    gearButton
                }
                .frame(height: 80)
                .padding(.horizontal)
                
                ScrollView {
                    ForEach(vm.users) { user in
                        
                        NavigationLink {
                            ChatLogView(user: user)
                        } label: {
                            UserChatView(user: User())
                        }
                        
                        Divider()
                    }
                    .background(Color.black)
                }
                .padding(.horizontal)
                .colorScheme(.dark)
                .navigationBarHidden(true)
                //End of VStack
                
                NavigationLink("", isActive: $vm.showLogView) {
                    ChatLogView(user: vm.user)
                }
                
                
                newMessageButton
                    .fullScreenCover(isPresented: $vm.createNewMessage) {
                        NewMessageView(vm: vm)
                    }

              
            }

        }
        .colorScheme(.dark)
        //End of NavView
    }
}

extension MainMessageView {
    
    private var userStatus: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(displayName ?? "")
                .fontWeight(.thin)
                .font(.title2)
            HStack {
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 14, height: 14)
                Text("Online")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontWeight(.thin)
            }
        }
    }
    
    private var gearButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "gear")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
        }
    }
    
    
    private var newMessageButton: some View {
        Button {
            vm.createNewMessage.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                Spacer()
            }
            .frame(height: 45)
            .foregroundColor(.black)
            .background(Color.cx_orange)
            .cornerRadius(32)
            .padding(.horizontal)
        }
    }
    
}

struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessageView()
    }
}
