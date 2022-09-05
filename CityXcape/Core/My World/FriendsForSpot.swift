//
//  FriendsForSpot.swift
//  CityXcape
//
//  Created by James Allan on 9/4/22.
//

import SwiftUI
import Shimmer

struct FriendsForSpot: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var vm: SpotViewModel
    var spot: SecretSpot
    
    var body: some View {
        VStack {
            HStack {
                Text("Choose a friend")
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ScrollView {
                ForEach(vm.users) { user in
                    
                    Button {
                        vm.shareSecretSpot(spot: spot, user: user)
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            VStack {
                                UserDotView(imageUrl: user.profileImageUrl, width: 80)
                                Text(user.displayName)
                                    .fontWeight(.thin)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            VStack {
                                Image(user.rank ?? "Tourist")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                                Text(user.rank ?? "Tourist")
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    
                }
            }
            
            Spacer()
        }
        .background(
            ZStack {
                Color.black
                Image("colored-paths")
                    .opacity(0.5)
                    .shimmering(active: true, duration: 5, bounce: true)
                
            }
        )
        .edgesIgnoringSafeArea(.bottom)
    }
}



struct FriendsForSpot_Previews: PreviewProvider {
    static var previews: some View {
        FriendsForSpot(vm: SpotViewModel(), spot: SecretSpot.spot)
    }
}
