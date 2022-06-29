//
//  InstagramView.swift
//  CityXcape
//
//  Created by James Allan on 5/6/22.
//

import SwiftUI

struct StampImage: View {
    
    let width: CGFloat
    let height: CGFloat
    let image: UIImage
    let title: String
    let date: Date
    
    let screenWidth = UIScreen.screenWidth
    
    var body: some View {
        
            ZStack {
              
                imageFrame
                
                stamp
                
            }
            .background(Color.white)
            .frame(width: width, height: height)
            .clipShape(Rectangle())



    }
    
}

extension StampImage {
    
    private var titleBar: some View {
        HStack {
            Image("pin_blue")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text(title)
                .font(.title2)
                .fontWeight(.thin)
        }
    }
    private var imageFrame: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(width: width, height: height)
            
            
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width - 20, height: height - 20)
        
        }
        .clipped()
    }
    
    private var stamp: some View {
        Image("Stamp")
          .resizable()
          .frame(width: width / 2, height: width / 2)
          .scaledToFit()
          .rotationEffect(Angle(degrees: -30))
          .overlay(
              VStack {
                  Text(title)
                  Text(date.formattedDate())
                      .font(.caption2)
              }
              .foregroundColor(.stamp_red)
              .rotationEffect(Angle(degrees: -60))
          )
    }
    
    private var logoBrand: some View {
          
               HStack {
                   Spacer()
                   Image("logo")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 1000)
                   Spacer()
           }
            .frame(width: width - 40)
        
    }
    
}

struct InstagramView_Previews: PreviewProvider {
    
    static var previews: some View {
        let image = UIImage(named: "Photo")!
        StampImage(width: 500, height: 500 , image: image, title: "The Big Duck", date: Date())
            .previewLayout(.sizeThatFits)
    }
    
}

