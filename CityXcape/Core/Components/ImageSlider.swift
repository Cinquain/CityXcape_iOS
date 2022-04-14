//
//  ImageSlider.swift
//  CityXcape
//
//  Created by James Allan on 4/13/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageSlider: View {
    
    var images: [String]
    
    var body: some View {
        TabView {

            ForEach(images, id: \.self) { url in
                
                    WebImage(url: URL(string: url))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: .infinity)
                        .overlay(
                            ZStack {
                                LinearGradient(colors: [Color.clear, Color.black], startPoint: .center, endPoint: .bottom)
                        
                            })
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
