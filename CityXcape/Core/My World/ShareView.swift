//
//  ShareView.swift
//  CityXcape
//
//  Created by James Allan on 5/7/22.
//

import SwiftUI

struct ShareView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: SpotViewModel
    @State var spot: SecretSpot
    var width: CGFloat = UIScreen.screenWidth

    var body: some View {
        
        ZStack {
            AnimationView()
            
            VStack {
                Spacer()
                    .frame(height: width / 4)
                
                
                Text("Congrats! \n You verified \(spot.spotName)")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                
                StampImage(width: width, height: width, image: vm.journeyImage ?? UIImage(), title: spot.spotName, date: Date())
                 
                
                Button {
                        vm.analytics.viewedRanks()
                        vm.showRanks.toggle()
                } label: {
                    VStack {
                        Text("Your rank is: \(vm.rank)")
                            .font(.title3)
                            .fontWeight(.thin)
                        
                        BarView(progress: vm.progressValue)

                        Text("\(vm.progressString)")
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                }
                .sheet(isPresented: $vm.showRanks) {
                    Ranks()
                }

           
                
                HStack {
                    
                    Button {
                        vm.analytics.viewedLeaderBoard()
                        vm.getScoutLeaders()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            vm.showLeaderboard.toggle()
                        }
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
                    
                    
                    Spacer()
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
                .padding()
            }
            
            //End of ZStack
        }
        .background(.black)
        .edgesIgnoringSafeArea(.all)
    
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(vm: SpotViewModel(), spot: SecretSpot.spot)
    }
}
