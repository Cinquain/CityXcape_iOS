//
//  SaveDetailsView.swift
//  CityXcape
//
//  Created by James Allan on 2/1/22.
//

import SwiftUI

struct SavesView: View {
    
    var spot: SecretSpot
    @StateObject var vm: SpotViewModel
    @State private var currentUser: User?
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack() {
            HStack {
                SecretSpotView(width: 80, height: 80, imageUrl: spot.imageUrls.first ?? "")
                Text(getMessage())
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            
            Divider()
                .frame(height: 0.5)
                .background(Color.white)
            
            Spacer()
                .frame(height: 40)
            
            ScrollView {
                
                ForEach(vm.users) { user in
                    
                    HStack {
                        Button {
                            currentUser = user
                        } label: {
                            VStack {
                                UserDotView(imageUrl: user.profileImageUrl, width: 80, height: 80)
                                Text(user.displayName)
                                    .fontWeight(.thin)
                                    .frame(width: 70)
                                    .lineLimit(1)
                            }
                        }
                        .sheet(item: $currentUser) {
                            //Tbd
                        } content: { user in
                            PublicStreetPass(user: user)
                        }

                        
                        Spacer()
                        
                        Button {
                            showAlert.toggle()
                        } label: {
                            Text("Explore with \(user.displayName)")
                                .font(.caption)
                                .fontWeight(.thin)
                                .frame(width: 120, height: 40)
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .background(Color.cx_orange)
                                .opacity(0.9)
                                .cornerRadius(3)
                                .padding()
                                
                        }
                        .alert(isPresented: $showAlert) {
                            return Alert(title: Text("Feature Coming Soon..."), message: nil)
                        }
                        //End of Hstack
                    }
                    .padding(.horizontal, 12)
                    
                    Divider()
                        .frame(height: 0.3)
                        .background(Color.gray)
                }
                
            }
          
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    fileprivate func getMessage() -> String {
        if vm.users.count <= 1 {
            return "\(vm.users.count) Person wants to visit \(spot.spotName)"
        } else {
            return "\(vm.users.count) People want to visit \(spot.spotName)"
        }
    }

}

struct SaveDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm: SpotViewModel = SpotViewModel()

        SavesView(spot: SecretSpot.spot, vm: vm)
    }
}
