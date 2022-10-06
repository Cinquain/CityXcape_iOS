//
//  RequestList.swift
//  CityXcape
//
//  Created by James Allan on 10/3/22.
//

import SwiftUI

struct RequestList: View {
    @Environment(\.presentationMode) var presentationMode

    @State var friends: [User]
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    @State var showStreetPass: Bool = false
    var body: some View {
        VStack {
            HStack {
                Image("dot")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                Text("\(friends.count) Pending Friend Request")
                    .font(.title2)
                    .fontWeight(.thin)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            
            List {
                ForEach(friends) { user in
                    HStack {
                        Button {
                            showStreetPass.toggle()
                        } label: {
                            VStack(spacing: 0) {
                                UserDotView(imageUrl: user.profileImageUrl, width: 80)
                                Text(user.displayName)
                                    .fontWeight(.thin)
                                    .lineLimit(1)
                                    .frame(width: 100)
                            }
                        }
                        .sheet(isPresented: $showStreetPass) {
                            PublicStreetPass(user: user)
                        }
                    }
                    .padding(.horizontal, 20)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Accept") {
                            acceptFriendRequest(user: user)
                        }
                        .tint(.green)
                        
                        Button("Delete") {
                            delete(user: user)
                        }
                        .tint(.red)
                    }
                }
              
              
            }
            .colorScheme(.dark)
            .listStyle(.inset)
            Spacer()
            
            Button {
                //
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .opacity(0.5)
            }
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    
    fileprivate func delete(user: User) {
        DataService.instance.deleteFriendRequest(user: user) { result in
            switch result {
                case .success(_):
                    self.alertMessage = "Friend request has been added deleted"
                    self.showAlert = true
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
            }
        }
    }
    
    
    func acceptFriendRequest(user: User) {
        DataService.instance.saveNewUserAsFriend(user: user) {  result in
            switch result {
                case .success(_):
                    self.alertMessage = "\(user.displayName) has been added as a friend"
                    AnalyticsService.instance.newFriends()
                    self.showAlert = true
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
            }
        }
       
    }
}

struct RequestList_Previews: PreviewProvider {
    static var previews: some View {
        RequestList(friends: [User(id: "abcafg", displayName: "Cinquain", profileImageUrl: "https://assets.mubicdn.net/images/film/50471/image-w1280.jpg?1611049910")])
    }
}
