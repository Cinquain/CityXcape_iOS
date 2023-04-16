//
//  TrailCardView.swift
//  CityXcape
//
//  Created by James Allan on 4/4/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TrailCardView: View {
    
    let trail: Trail
    let width: CGFloat = UIScreen.screenWidth
    @State private var showDetails: Bool = false
    
    var body: some View {
        
        VStack {
            ImageSlider(images: trail.imageUrls)
            Spacer()
        }
        .overlay(
            VStack {
                Text(trail.name)
                    .font(Font.custom("Savoye LET", size: 34))
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .shadow(color: .black, radius: 12)
                    .padding(.top, 10)
                Spacer()
                if showDetails {
                    showDescription()
                } else {
                    infoBar()
                }
            }
        )
        .frame(width: width, height: 250)
        .cornerRadius(25)
        
    }
    
    @ViewBuilder
    func infoBar() -> some View {
        HStack {
            Button {
                withAnimation(.easeOut(duration: 0.3)) {
                    showDetails.toggle()
                }
            } label: {
                WebImage(url: URL(string: trail.tribeImageUrl ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                
            }
            
            Spacer()
            
            Image("pin_blue")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text("\(trail.spots.count) spots")
                .foregroundColor(.white)
                .fontWeight(.thin)
        }
        .padding()
    }
    
    @ViewBuilder
    func showDescription() -> some View {
        Text(trail.description)
            .font(.title2)
            .foregroundColor(.white)
            .fontWeight(.thin)
            .padding(.bottom, 10)
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.3)) {
                    showDetails.toggle()
                }
            }
    }
    
}

struct TrailCardView_Previews: PreviewProvider {
    static var previews: some View {
        TrailCardView(trail: Trail.demo2)
            .previewLayout(.sizeThatFits)
    }
}
