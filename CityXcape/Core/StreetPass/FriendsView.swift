//
//  FriendsView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/22.
//

import SwiftUI

struct FriendsView: View {
    @StateObject var vm: StreetPassViewModel
    @Environment(\.presentationMode) var presentationMode
    let height: CGFloat = UIScreen.screenHeight
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    
    var body: some View {
        NavigationView {
                
            List {
                ForEach(vm.friends) { user in
                    VStack {
                     
                        NavigationLink {
                            ChatLogView(user: user)
                        } label: {
                            UserChatView(user: user)
                        }
                        
                        Divider()
                    }
                    .swipeActions {
                           Button("UnFriend") {
                               vm.deleteFriend(user: user)
                           }
                           .tint(.red)
                       }
                    .listRowInsets(EdgeInsets())

                    
                }
                .padding(.top, 20)

                
                
            }
            .listStyle(PlainListStyle())
            .background(background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("dot").resizable().scaledToFit().frame(height: 30)
                        Text(vm.getFriendsText())
                    }.foregroundColor(.white)
                    }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .onAppear {
                vm.fetchAllFriends()
                vm.count = 0
            }
            
        }
        .colorScheme(.dark)

    }

}


extension FriendsView {

    private var background: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            Image("colored-paths")
                .resizable()
                .scaledToFit()
                .opacity(0.5)
                .shimmering(active: true, duration: 3, bounce: true)
        }
    }
    
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView(vm: StreetPassViewModel())
    }
}
