//
//  UserDotView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct UserDotView: View {
    
    let image: Image
    let width: CGFloat
    let height: CGFloat
    let ratio : CGFloat = 1.3
    
    var body: some View {
        
        ZStack {
            Image(AppIcon.dot.rawValue)
                .resizable()
                .frame(width: width, height: height, alignment: .center)
                .overlay(
                    image
                        .resizable()
                        .frame(width: width / ratio, height: height / ratio, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                )
            
        }
    }
}

struct UserDotView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let dummyImage = Image("User")
        
        UserDotView(image: dummyImage, width: 150, height: 150)
    }
}
