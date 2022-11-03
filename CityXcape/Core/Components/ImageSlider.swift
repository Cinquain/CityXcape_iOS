//
//  ImageSlider.swift
//  CityXcape
//
//  Created by James Allan on 4/13/22.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct ImageSlider: View {
    
    var images: [String]
    var width: CGFloat = UIScreen.screenWidth
    var body: some View {
        TabView {

            ForEach(images, id: \.self) { url in
                if url.isImageUrl() {
                    WebImage(url: URL(string: url))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width)
                        .clipped()
                        .overlay(
                            ZStack {
                                LinearGradient(colors: [Color.clear, Color.black], startPoint: .center, endPoint: .bottom)
                        
                            })
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                } else {
                    VideoPlayer(player: AVPlayer(url:  URL(string: url)!))
                        .frame(height: width)
                }
              
            }
      
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ImageSlider_Previews: PreviewProvider {
    static var previews: some View {
        ImageSlider(images: [""])
    }
}
