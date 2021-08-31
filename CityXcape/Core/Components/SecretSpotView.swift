//
//  SecretSpotView.swift
//  CityXcape
//
//  Created by James Allan on 8/18/21.
//

import SwiftUI

struct SecretSpotView: View {
    
    let width: CGFloat
    let height: CGFloat
    let imageUrl: String
    
    var body: some View {
        
        Image(Icon.pin.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
            .overlay(
                Image(imageUrl)
                    .resizable()
                    .frame(width: width / 1.35, height: height / 1.35)
                    .cornerRadius(40)
                    .offset(.init(width: -0.3, height: -5))
            )
            .shadow(radius: 3)
    }
}

struct SecretSpotView_Previews: PreviewProvider {
    static var previews: some View {
        SecretSpotView(width: 100, height: 100, imageUrl: "donut")
    }
}
