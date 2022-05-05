//
//  UserDiscoveryView.swift
//  CityXcape
//
//  Created by James Allan on 4/5/22.
//

import SwiftUI
import FirebaseMessaging

struct UserDiscoveryView: View {
    
    @StateObject var vm: DiscoverViewModel
    @State var currentUser: User?
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Top Scouts")
                    .font(.title)
                    .fontWeight(.thin)
                Spacer()
                
                Button {
                    vm.refreshSecretSpots()
                    AnalyticsService.instance.loadedNewSpots()
                } label: {
                    VStack {
                        Text("Refresh")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 120, height: 40)
                            .background(Color.white)
                            .foregroundColor(.cx_blue)
                            .cornerRadius(20)
                    }
                }
            }
            .foregroundColor(.white)
            
            Spacer()
                .frame(height: 40)
            
            ScrollView {
                ForEach(vm.rankings) { rank in
                    
                    HStack {
                        Button {
                            currentUser = User(rank: rank)
                            vm.showStreetPass.toggle()
                        } label: {
                            VStack {
                                UserDotView(imageUrl: rank.profileImageUrl, width: 100)
                                Text(rank.displayName)
                                    .fontWeight(.thin)
                                    .frame(width: 70)
                                    .lineLimit(1)
                            }
                            .foregroundColor(.white)
                        }
                        .sheet(item: $currentUser) { user in
                            PublicStreetPass(user: user)
                        }
                    
                        
                        Spacer()
                        
                        VStack {
                            HStack {
                                Image("pin_blue")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 25)
                                Text("\(rank.totalSpots) spots posted")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .fontWeight(.thin)
                            }
                            .frame(width: 120)
                            
                            Button {
                                NotificationsManager.instance.checkAuthorizationStatus { fcmToken in
                                    if let fcmToken = fcmToken {
                                        vm.streetFollow(rank: rank, fcm: fcmToken)
                                    } else {
                                        vm.alertMessage = "Notification Permission is required"
                                        vm.showAlert.toggle()
                                    }
                                }
                            } label: {
                                Text("Street Follow")
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .foregroundColor(.orange)
                                    .frame(width: 120, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                                     .stroke(Color.orange, lineWidth: 1)
                                    )
                            }
                            .alert(isPresented: $vm.showAlert) {
                                return Alert(title: Text(vm.alertMessage))
                            }
                        }
                        
                        
                        //End of row
                    }
                    
                }
        }
            
            
            
            
        
    }
    .padding(.horizontal,20)
    .background(Color.black)

}
}

struct UserDiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        UserDiscoveryView(vm: DiscoverViewModel())
    }
}
