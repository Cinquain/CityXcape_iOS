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
    @State private var currentSpot: SecretSpot?
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var passed: Bool = false
    @State private var saved: Bool = false
    @State var searchTerm: String = ""

    
    @Binding var selectedTab: Int
    @Binding var spotCount: Int
    
    @StateObject var vm: DiscoverViewModel = DiscoverViewModel()

    
    var body: some View {
        
      
        
        VStack(spacing: 20) {
            
            Ticker(searchText: $searchTerm, handlesearch: {
                vm.performSearch(searchTerm: searchTerm)
            })
            
            
            ScrollView {
                if vm.newSecretSpots.isEmpty {
                    UserDiscoveryView(vm: vm)
                    .opacity(vm.finished ? 1 : 0)
                    
                } else {
                    
                    withAnimation(_: .easeOut) {
                        ForEach(vm.newSecretSpots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser})) { spot in

                            ZStack {
                              
                                CardView(showAlert: $vm.showAlert, alertMessage: $vm.alertMessage, spot: spot)
                                    .animation(Animation.linear(duration: 0.4))

                                
                                LikeAnimationView(color: .cx_green, didLike: $vm.passed, size: 200)
                                    .opacity(currentSpot == spot && vm.saved ? 1 : 0)
                                    .animation(Animation.linear(duration: 0.5))

                                    
                                Image(systemName: "hand.thumbsdown.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .foregroundColor(.stamp_red)
                                    .opacity(currentSpot == spot && vm.passed ? 1 : 0)
                                    .animation(Animation.linear(duration: 0.5))
                            }
                            
                            HStack {
                                Button {
                                    //TBD
                                    currentSpot = spot
                                    vm.passed = true
                                    vm.dismissCard(spot: spot)
                                } label: {
                                    VStack {
                                        Image(systemName: "hand.thumbsdown")
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
                                    currentSpot = spot
                                    vm.saved = true
                                    vm.saveCardToUserWorld(spot: spot)
                                } label: {
                                    VStack {
                                        Image(systemName: "heart")
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
                                .frame(height: 0.5)
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
