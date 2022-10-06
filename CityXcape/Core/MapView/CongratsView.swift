//
//  CongratsView.swift
//  CityXcape
//
//  Created by James Allan on 8/31/21.
//

import SwiftUI

struct CongratsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @State private var presentAlert: Bool  = false
    let width: CGFloat = UIScreen.screenWidth
    @StateObject var vm: PostViewModel
    

    var body: some View {
        
      
            VStack {
                
                Spacer()
                    .frame(height: 50)
                
                VStack {
                    
                    Text("You earned 1 Streetcred")
                        .font(.title2)
                        .fontWeight(.thin)
                        .multilineTextAlignment(.center)
                   
                    Image(Icon.pin.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width / 2)
                    
               
                    HStack {
                        Spacer()
                        Button {
                                vm.analytics.viewedRanks()
                                vm.showRanks.toggle()
                            } label: {
                                VStack {
                                    Text("Current Rank: \(vm.rank)")
                                    BarView(progress: vm.progressValue)
                                    Text(vm.progressString)
                                        .font(.caption)
                                        .fontWeight(.thin)

                                }
                                .foregroundColor(.white)

                            }
                            .sheet(isPresented: $vm.showRanks) {
                                Ranks()
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    
                    HStack {
                        
                        Button {
                            vm.analytics.viewedLeaderBoard()
                            vm.showLeaderboard.toggle()
                        } label: {
                            
                            HStack(alignment: .center) {
                                Spacer()
                                Image("leaderboard")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.cx_orange)
                                    .scaledToFit()
                                .frame(height: 30)
                                
                                Text("Leaderboard")
                                    .foregroundColor(.cx_orange)
                                    .font(.title3)
                                    .fontWeight(.thin)
                                Spacer()
                            }
                            
                       
                        }
                        .sheet(isPresented: $vm.showLeaderboard) {
                            Leaderboard(ranks: vm.rankings)
                        }
                        
                        
                    }
                    
                    
                  
                    Spacer()
                        .frame(maxHeight: 50)
                    
                    Button(action: {
                            vm.checkforNotifications()
                            vm.analytics.postSecretSpot()
                            vm.didFinish = true
                            presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        HStack {
                            Image(Icon.check.rawValue)
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Done!")
                                .font(.caption)
                        }
                    })
                    .padding()
                    .frame(width: 150, height: 50)
                    .background(Color.black.opacity(0.9))
                    .foregroundColor(.blue)
                    .cornerRadius(5)
                    
                }
                .foregroundColor(.white)
                
                Spacer()
            
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]), startPoint: .center, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
        
    }
    
    

    
}

struct CongratsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratsView(vm: PostViewModel())
    }
}
