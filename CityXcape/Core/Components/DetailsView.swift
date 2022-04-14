//
//  DetailsView.swift
//  CityXcape
//
//  Created by James Allan on 4/13/22.
//

import SwiftUI

struct DetailsView: View {
    var spot: SecretSpot
    @State private var showStreetPass: Bool = false
    var vm: SpotViewModel
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack {
                Text(spot.description ?? "No Description has been posted for this spot")
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .lineLimit(.none)
                    .padding()
                
            }
            .padding(.horizontal, 20)
            
         
            
            HStack(spacing: 10) {
                
                HStack(spacing: 2) {
                    Image(systemName: "eye.fill")
                        .font(.title2)
                    Text(vm.getViews(spot: spot))
                           .font(.title3)
                           .fontWeight(.thin)
                           .foregroundColor(.white)
                           .lineLimit(1)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    Image(systemName: "figure.walk")
                        .font(.title2)
                    Text(vm.getDistanceMessage(spot: spot))
                           .font(.title3)
                           .fontWeight(.thin)
                           .foregroundColor(.white)
                           .lineLimit(1)
                }
                
                Spacer()
             
             
                        
                    HStack(spacing: 2) {
                        Image("globe")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 30)
                        
                        Text("\(spot.world)")
                            .font(.subheadline)
                            .fontWeight(.thin)
                            .lineLimit(1)
                            .frame(width: 60)

                    }
                    
                    
        
                
            }
            .padding(.horizontal, 20)
            
            
            HStack {
                Button {
                    showStreetPass.toggle()
                } label: {
                    VStack(spacing: 2) {
                        UserDotView(imageUrl: spot.ownerImageUrl, width: 60)
                        Text(spot.ownerDisplayName)
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                }
                .sheet(isPresented: $showStreetPass) {
                    let user = User(id: spot.ownerId, displayName: spot.ownerDisplayName, profileImageUrl: spot.ownerImageUrl)
                    PublicStreetPass(user: user)
                }

                Spacer()
                
                Button(action: {
                    vm.showActionSheet.toggle()
                 }, label: {
                     
                     VStack {
                         Image(systemName: "ellipsis")
                             .font(.title)
                             .foregroundColor(.white)
                         .rotationEffect(.init(degrees: 90))
                         
                     }
                 })
            }
            .padding(.horizontal, 20)
            
            
        }
        .background(Color.black.opacity(0.5))
        .foregroundColor(.white)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(spot: SecretSpot.spot, vm: SpotViewModel())
            .previewLayout(.sizeThatFits)
    }
}
