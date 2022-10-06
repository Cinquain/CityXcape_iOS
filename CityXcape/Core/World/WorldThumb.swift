//
//  WorldThumb.swift
//  CityXcape
//
//  Created by James Allan on 9/12/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct WorldThumb: View {
    let width: CGFloat = UIScreen.screenWidth
    @State private var showDetails: Bool = false
    @State private var showActionSheet: Bool = false
    var world: World
    
    var body: some View {
        ZStack(alignment: .bottom) {
            background
            
            VStack(spacing: 0) {
                
                Spacer()
                HStack {
                    Text(world.description)
                        .fontWeight(.thin)
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .lineLimit(.none)
                        .padding()
                    
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                
                HStack {
                    Image("pin_blue")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    Text("\(world.spotCount) spots")
                        .fontWeight(.thin)
                    Spacer()
                    Image("dot")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    Text("\(world.memberCount) members")
                        .fontWeight(.thin)
                }
                .foregroundColor(.white)
                .padding(.bottom, 20)
                .padding(.horizontal, 10)
            }
            .frame(height: 250)
            .opacity(showDetails ? 1 : 0)
            .animation(.easeOut(duration: 0.5), value: showDetails)
            .onTapGesture {
                showDetails.toggle()
            }
            
            buttonRow
        }
    }
}


extension WorldThumb {
    
    private var background: some View {
        WebImage(url: URL(string: world.coverImageUrl))
            .resizable()
            .scaledToFit()
            .frame(width: width)
            .cornerRadius(12)
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        WebImage(url: URL(string: world.imageUrl))
                            .resizable()
                            .scaledToFit()
                            .frame(width: width / 3)
                            .opacity(0.6)
                            .opacity(showDetails ? 0 : 1)


                    }
                    .padding(.horizontal, 10)
                }
                .background(
                    LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
                )
            }
    }
    
    private var buttonRow: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    showDetails.toggle()
                } label: {
                    Image("info")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                        .padding(.leading, 4)
                        .opacity(showDetails ? 0 : 1)

                }

                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 70)
    }
    
}

struct WorldThumb_Previews: PreviewProvider {
    static var previews: some View {
        
        let data: [String: Any] = [
            WorldField.id: "abc123",
            WorldField.name: "Scout",
            WorldField.description: "We are a community of explorers who scavenge for cool 💎 gems anywhere. We like to find cool spots and learn why they are special.",
            WorldField.hashtags: "#Scout, #ScoutLife, #GetYoStamp",
            WorldField.imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/Worlds%2FScout%2FScout.png?alt=media&token=d4320920-4644-4d99-8636-a3190378ed50",
                WorldField.coverImageUrl: "https://www.womenontopp.com/wp-content/uploads/2019/09/pexels-inga-seliverstova-3394225.jpg",
            WorldField.membersCount: 123,
            WorldField.spotCount: 99,
            WorldField.initiationFee: 0,
            WorldField.monthlyFee: 0,
            WorldField.dateCreated : Date(),
            WorldField.ownerId: "skfhfif",
            WorldField.isPublic: true,
            WorldField.ownerEmail: "James@cityXcape.com",
            WorldField.ownerName: "Cinquain",
            WorldField.ownerImageUrl: ""
        ]
   
        let world = World(data: data)
        
        WorldThumb(world: world)
            .previewLayout(.sizeThatFits)
    }
}
