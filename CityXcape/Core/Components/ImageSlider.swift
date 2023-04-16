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
        ImageSlider(images: ["https://www.southernliving.com/thmb/guNnKC5ZnAcVLsQlq73_pmOR_14=/750x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-144938832-1-b64bf4fb82b34d4e8f8a44cb4a36a402.jpg", "https://pbs.twimg.com/media/CmD_27cXIAEeHqk?format=jpg&name=large"])
    }
}
