//
//  VerificationView.swift
//  CityXcape
//
//  Created by James Allan on 2/24/22.
//

import SwiftUI

struct VerificationView: View {
    
    var spot: SecretSpot
    var vm: SpotViewModel
    
    @State private var currentUser: User?

    var body: some View {
        
        VStack {
            HStack {
                SecretSpotView(width: 80, height: 80, imageUrl: spot.imageUrls.first ?? "")
                Text(getMessage())
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 15)
            
            Divider()
                .frame(height: 0.5)
                .background(Color.white)
            
            Spacer()
                .frame(height: 40)
            
            ScrollView {
                
                ForEach(vm.users) { user in
                    
                    HStack {
                        Button {
                            //TBD
                            self.currentUser = user
                        } label: {
                            
                            VStack(spacing: 0) {
                                UserDotView(imageUrl: user.profileImageUrl, width: 80, height: 80)
                                Text(user.displayName)
                                    .fontWeight(.thin)
                                    .frame(width: 70)
                                    .lineLimit(1)
                            }
                        }
                        .sheet(item: $currentUser) { user in
                            PublicStreetPass(user: user)
                        }
                        
                        Spacer()
                        
                        Button {
                            //TBD
                        } label: {
                            
                            VStack(spacing: 4) {
                                Image("checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.5)
                                    .frame(width: 35)
                                Text("Verified on \n \(user.verified?.description ?? "")")
                                    .fontWeight(.thin)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.trailing, 10)
                        }


                    }
                    .padding(.horizontal, 12)
                    
                    Divider()
                        .frame(height: 0.3)
                        .background(Color.gray)
                        .padding(.horizontal, 12)
                }
                
            }
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        
    }
    
    fileprivate func getMessage() -> String {
        if vm.users.count <= 1 {
            return "\(vm.users.count) Person verified \(spot.spotName)"
        } else {
            return "\(vm.users.count) People verified \(spot.spotName)"
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        VerificationView(spot: SecretSpot.spot, vm: SpotViewModel())
    }
}
