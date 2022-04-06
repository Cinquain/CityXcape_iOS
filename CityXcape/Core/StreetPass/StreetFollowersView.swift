//
//  StreetFollowersView.swift
//  CityXcape
//
//  Created by James Allan on 4/4/22.
//

import SwiftUI

struct StreetFollowersView: View {
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @Environment(\.presentationMode) var presentationMode


    @StateObject var vm: StreetPassViewModel
    @State private var currentUser: User?
    var body: some View {
        VStack {
            HStack {
                VStack(spacing:0) {
                    UserDotView(imageUrl:profileUrl ?? "", width: 80, height: 80)
                    Text(displayName ?? "")
                        .fontWeight(.thin)
                }
                Text("Street Influence")
                    .font(.title)
                    .fontWeight(.thin)
                    .padding(.bottom, 20)
                    .padding(.leading, 15)

                Spacer()
            }
            .foregroundColor(.white)
            .padding(.leading, 20)
            
            Spacer()
                .frame(height: 30)
            
            Picker("Picker", selection: $vm.showFollowing) {
                Text("Street Followers")
                    .tag(false)
                
                Text("Following")
                    .tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .foregroundColor(.cx_orange)
            .colorScheme(.dark)
            .padding()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    ForEach(vm.streetFollowers) { user in
                        
                        HStack {
                            
                            Button {
                                //TBD
                            } label: {
                                VStack(spacing: 0) {
                                    UserDotView(imageUrl: user.profileImageUrl, width: 80, height: 80)
                                    Text(user.displayName)
                                        .fontWeight(.thin)
                                }
                            }
                            .sheet(item: $currentUser) { user in
                                PublicStreetPass(user: user)
                            }
                            
                            Spacer()
                            
                            Text(user.membership?.timeFormatter() ?? "")
                                .fontWeight(.thin)
                            
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        
                    }
                    
                }
                
            }
            
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
    }
}

struct StreetFollowersView_Previews: PreviewProvider {
    static var previews: some View {
        StreetFollowersView(vm: StreetPassViewModel())
    }
}
