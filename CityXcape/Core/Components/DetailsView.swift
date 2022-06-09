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
    @Binding var showActionSheet: Bool
    var type: DetailsMode

    
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
                    Text(getViews(spot: spot))
                           .font(.title3)
                           .fontWeight(.thin)
                           .foregroundColor(.white)
                           .lineLimit(1)
                }
                
                Spacer()
                
                if type == .SpotDetails {
                    HStack(spacing: 2) {
                        Image(systemName: "figure.walk")
                            .font(.title2)
                        Text(getDistanceMessage(spot: spot))
                               .font(.title3)
                               .fontWeight(.thin)
                               .foregroundColor(.white)
                               .lineLimit(1)
                    }
                } else {
                    
                    Button {
                        //TBD
                     
                    } label: {
                        VStack {
                            Text("\(spot.price)")
                                .font(.title2)
                                .fontWeight(.light)
                                .frame(width: 20)
                                .foregroundColor(.cx_green)

                            
                            Text("STC")
                                .font(.caption)
                                .fontWeight(.thin)
                                .foregroundColor(.cx_green)
                        }
                    }
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
                    let user = User(spot: spot)
                    PublicStreetPass(user: user)
                }

                Spacer()
                
                Button(action: {
                    showActionSheet.toggle()
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
    
    
    
    fileprivate func getDistanceMessage(spot: SecretSpot) -> String {
        
        if spot.distanceFromUser < 1 {
            return "\(String(format: "%.1f", spot.distanceFromUser)) mile"
        } else if spot.distanceFromUser < 10 {
            return "\(String(format: "%.1f", spot.distanceFromUser)) miles"
        } else {
            return "\(spot.city)"
        }
    }
    
    fileprivate func getViews(spot: SecretSpot) -> String {
        if spot.viewCount > 1 {
            return "\(spot.viewCount) views"
        } else {
            return "\(spot.viewCount) view"
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    
    @State static var boolean: Bool = false

    static var previews: some View {
        DetailsView(spot: SecretSpot.spot, showActionSheet: $boolean, type: .CardView)
            .previewLayout(.sizeThatFits)
    }
}
