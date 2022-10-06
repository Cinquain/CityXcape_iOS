//
//  MainWorldPage.swift
//  CityXcape
//
//  Created by James Allan on 9/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainWorldPage: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    var width: CGFloat = UIScreen.screenWidth
    @StateObject var vm: WorldViewModel
    
    var body: some View {
        
        VStack {
          
              
            
            VStack {
                Text("Your Street Report Card")
                    .font(.title2)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                
                HStack(spacing: 100) {
                    
                    userStats
                    
                    VStack(spacing: 15) {
                        ProgressCircle(size: vm.progressValue, progress: 0.5, rank: vm.rank)
                        Text("Your rank")
                            .font(.callout)
                            .fontWeight(.thin)
                            .foregroundColor(.white)
                    }
                    
                }
            }
            .padding(.bottom, 30)

            
            HStack {
                Spacer()
                
                VStack(spacing: 0) {
                    Button {
                        vm.getScoutLeaders()
                        vm.showLeaders.toggle()
                    } label: {
                        VStack {
                            WebImage(url: URL(string: vm.world?.imageUrl ?? ""))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                            .opacity(0.8)
                            Text("Community Leaders")
                                .fontWeight(.thin)
                        }
                    }
                  
                }
                .sheet(isPresented: $vm.showLeaders) {
                    Leaderboard(ranks: vm.ranking)
                }
            
                
                Spacer()
       
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)

      
            
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

       
            
            Spacer()
        }
        .background(
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.cx_orange.opacity(0.5),]), startPoint: .center, endPoint: .bottom)
                    .cornerRadius(25).edgesIgnoringSafeArea(.bottom)
            }
        )
    }
    
}

extension MainWorldPage {
    
    private var userStats: some View {
        VStack {
            
   
            
            VStack(spacing: 0) {
                BarView(progress: CGFloat(vm.totalSpots))
                HStack(spacing: 0) {
                    Text("\(vm.totalSpots) spots posted ")
                        .fontWeight(.thin)
                    Image("pin_blue")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
            }
            
            VStack(spacing: 0) {
                BarView(progress: CGFloat(vm.totalStamps))
                HStack(spacing: 0) {
                    Text("\(vm.totalStamps) spots verified ")
                        .fontWeight(.thin)
                    Image("Stamp")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
            }
            
            VStack(spacing: 0) {
                BarView(progress: CGFloat(vm.totalCities))
                HStack(alignment: .bottom, spacing: 0) {
                    Text("\(vm.totalCities) cities visited ")
                        .fontWeight(.thin)
                    Image("city")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
            }
          
            
        }
        .foregroundColor(.white)
    }
    
    
}

struct MainWorldPage_Previews: PreviewProvider {
    static var previews: some View {
        MainWorldPage(vm: WorldViewModel())
    }
}
