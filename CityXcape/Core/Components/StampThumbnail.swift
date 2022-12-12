//
//  PostalStampView.swift
//  CityXcape
//
//  Created by James Allan on 11/26/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct StampThumbnail: View {
    var stamp: Verification
    let width: CGFloat = UIScreen.screenWidth
    
    var body: some View {
        
            Image(Labels.postalStam.rawValue)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: width - 20, maxHeight: width - 20)
                .overlay {
                    WebImage(url: URL(string: stamp.imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: width - 40, maxHeight: width - 40)
                        .clipped()
                        .overlay(
                            VStack {
                                Spacer()
                                HStack(alignment: .top) {
                                    Spacer()
                                    Image(Labels.pin.rawValue)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 20)
                                    
                                    Text(stamp.name)
                                        .fontWeight(.thin)
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                    Spacer()
                                }
                            }
                                
                            ,alignment: .bottom
                        )
                        .padding()

                }
                
                
                    
                    
                
                    
    }
}

struct PostalStampView_Previews: PreviewProvider {
    static var previews: some View {
        StampThumbnail(stamp: Verification.demo)
            .previewLayout(.sizeThatFits)
    }
}
