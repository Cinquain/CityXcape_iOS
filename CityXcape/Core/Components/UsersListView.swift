//
//  FriendList.swift
//  CityXcape
//
//  Created by James Allan on 9/2/22.
//

import SwiftUI

struct UsersListView: View {
    
    @State var users: [User]
    @State private var showPass: Bool = false
    var body: some View {
        VStack {
            
            ScrollView {
                ForEach(users) { user in
                    HStack{
                   
                        Button {
                            showPass.toggle()
                        } label: {
                            VStack(spacing: 0) {
                                UserDotView(imageUrl: user.profileImageUrl, width: 80)
                                Text(user.displayName)
                                    .font(.callout)
                                    .fontWeight(.thin)
                            }
                        }
                        .sheet(isPresented: $showPass) {
                            PublicStreetPass(user: user)
                        }
                        
                        
                        Text(user.bio ?? "")
                            .fontWeight(.thin)
                            .padding(.leading, 20)
                        Spacer()

                        VStack(spacing: 0) {
                            Image(user.rank ?? "Tourist")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                            
                            Text(user.rank ?? "Tourist")
                                .font(.caption)
                                .fontWeight(.thin)
                        }
                    }
                    .padding(.horizontal, 20)
                    .foregroundColor(.white)
                }
            }
          Spacer()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            users.forEach { user in
                print("User is", user)
            }
        }
      
    }
   
}

struct FriendList_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView(users: [User()])
    }
}
