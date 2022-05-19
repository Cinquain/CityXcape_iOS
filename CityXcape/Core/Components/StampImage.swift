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
    
    var body: some View {
        
        ZStack {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: width, height: height)
                    .scaledToFit()
                    .overlay(
                        ZStack {
                            LinearGradient(colors: [Color.clear, Color.black], startPoint: .center, endPoint: .bottom)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image("logo")
                                        .resizable()
                                        .scaledToFit()
                                    .frame(width: 100)
                                }
                            }
                            .background(Color.clear)
                            .padding(20)
                        }
                        .frame(width: width, height: height)
                        .clipped()
                    )

            }
            .clipped()
            
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
        .frame(width: width, height: height)
        .clipped().edgesIgnoringSafeArea(.all)
    }
}

struct InstagramView_Previews: PreviewProvider {
    
    static var previews: some View {
        let image = UIImage(named: "Photo")!
        StampImage(width: 500, height: 500 , image: image, title: "The Big Duck", date: Date())
            .previewLayout(.sizeThatFits)
    }
    
}

