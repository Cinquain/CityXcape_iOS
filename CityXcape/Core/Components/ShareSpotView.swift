//
//  ShareSpotView.swift
//  CityXcape
//
//  Created by James Allan on 9/5/22.
//

import SwiftUI
import Shimmer
struct ShareSpotView: View {
    @Environment(\.presentationMode) var presentationMode

    var user: User
    @StateObject var vm: JourneyViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Choose the spot to share")
                    .font(.title2)
                    .fontWeight(.thin)
                Spacer()
            }
            .foregroundColor(.white)
            .background(.black)
            .padding(.horizontal, 20)
            
            ScrollView {
                ForEach(vm.spots) { spot in
                    
                    Button {
                        vm.shareSecretSpot(user: user, spot: spot)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            SecretSpotView(width: 75, height: 75.5, imageUrl: spot.imageUrls.first ?? "")
                            Text(spot.spotName)
                                .fontWeight(.thin)
                            Spacer()
                            VStack {
                                Image("world")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                                    .opacity(0.5)
                                Text(spot.world)
                                    .fontWeight(.thin)
                                    .font(.caption)
                                    .frame(maxWidth: 50)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
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

struct ShareSpotView_Previews: PreviewProvider {
    static var previews: some View {
        ShareSpotView(user: User(), vm: JourneyViewModel())
    }
}
