//
//  MissionsView.swift
//  CityXcape
//
//  Created by James Allan on 10/2/21.
//

import SwiftUI

struct DiscoverView: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @State private var isPresented: Bool = false
    @State private var spot: SecretSpot?
    @State private var currentIndex: Int = 0
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @Binding var selectedTab: Int
    @Binding var spotCount: Int
    
    @StateObject var vm: DiscoverViewModel = DiscoverViewModel()
    
    @State var captions: [String] = [
        "Discover New Places",
        "Save Places to Visit",
        "Saving a Spot Cost StreetCred"
    ]
    
    var body: some View {
        
      
        
        VStack(spacing: 20) {
            
            Ticker(profileUrl: profileUrl ?? "", captions: $captions)
                .frame(height: 100)
            
            
            ScrollView {
                if vm.newSecretSpots.isEmpty {
                    
                    VStack {
                        Spacer()
                        Image("404")
                            .resizable()
                            .scaledToFit()
                            .frame(height: UIScreen.screenWidth / 2)
                        
                        Text("No New Spots Were Found!")
                            .fontWeight(.thin)
                     
                    }
                    .opacity(vm.finished ? 1 : 0)
                    
                } else {
                    
                    withAnimation(_: .easeOut) {
                        ForEach(vm.newSecretSpots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser})) { spot in

                            CardView(showAlert: $vm.showAlert, alertMessage: $vm.alertMessage, spot: spot)
                            
                            HStack {
                                Button {
                                    //TBD
                                    vm.dismissCard(spot: spot)
                                } label: {
                                    VStack {
                                        Image(systemName: vm.passed ? "hand.thumbsdown.fill": "hand.thumbsdown")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.stamp_red)
                                            .frame(height: 30)

                                        Text("pass")
                                            .font(.caption)
                                            .foregroundColor(.stamp_red)
                                    }

                                }
                                
                                Spacer()
                                
                                Button {
                                    //TBD
                                    vm.saveCardToUserWorld(spot: spot)
                                } label: {
                                    VStack {
                                        Image(systemName:vm.saved ? "heart.fill" : "heart")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.cx_green)
                                            .frame(height: 30)
                                        
                                        Text("save")
                                            .font(.caption)
                                            .foregroundColor(.cx_green)
                                    }
                                }


                            }
                            .padding(.horizontal, 20)
                            
                            Divider()
                                .frame(height: 1)
                                .background(Color.white)
                                .padding(.bottom, 10)

                        }
                    }
                }
               
            
            }
            .frame(width: UIScreen.screenWidth)
          
  
            
            
        }
        .foregroundColor(.white)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .alert(isPresented: $vm.showAlert) {
            return Alert(title: Text(vm.alertMessage))
        }
    }
}

struct MissionsView_Previews: PreviewProvider {
    @State static var selection: Int = 0
    static var previews: some View {
        DiscoverView(selectedTab: $selection, spotCount: $selection)
    }
}
