//
//  InstagramView.swift
//  CityXcape
//
//  Created by James Allan on 5/6/22.
//

import SwiftUI

struct StampImage: View {
    

    let image: UIImage
    let title: String
    let date: Date
    let comment: String
    let width: CGFloat = 540
    let height: CGFloat = 540
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Image(Labels.postalStam.rawValue)
                .frame(width: width, height: height)
            
    
            imageFrame
                .overlay {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: width - 240)
                        
                        HStack {
                           dividers
                           stamp
                        }
                        Spacer()
                    }
                    .frame(width: width)
                    .background(LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom))
            }
        }
        .frame(height: height)
        .background(Color.black)
                

        //end of body
    }
    
}

extension StampImage {
    
    private var titleBar: some View {
        HStack(alignment: .bottom) {
            Image("pin_blue")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            
            Text(title)
                .font(Font.custom("Savoye LET", size: 32))
                 .fontWeight(.thin)
                 .foregroundColor(.white)
                 .lineLimit(1)
                 .multilineTextAlignment(.center)
            
        }
        
    }
    
    private var imageFrame: some View {
         
         
         ZStack {
             Rectangle()
                 .fill(.white)
                 .frame(width: width - 20, height: height - 20)
             Image(uiImage: image)
                 .resizable()
                 .scaledToFill()
                 .frame(width: width - 40, height: width - 40)
                 .clipped()
         }
             
     }
    
    private var stamp: some View {
        Image("Stamp")
          .resizable()
          .frame(width: 175, height: 175)
          .scaledToFit()
          .rotationEffect(Angle(degrees: -30))
          .overlay(
              VStack {
                  Text(title)
                      .font(.caption)
                  Text(date.formattedDate())
                      .font(.caption2)
              }
              .foregroundColor(.stamp_red)
              .rotationEffect(Angle(degrees: -60))
          )
    }

    
    private var dividers: some View {
        VStack(spacing: 0) {
            titleBar
                .frame(width: 170)
                .padding(.bottom, 10)

  
            VStack(spacing: 0) {
                Image("Logo Black")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .scaledToFit()
                    .frame(height: 50)
                
                Image("appstore")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .padding(.top, -5)
            }
            

            
        }
        
    }
    
    
}

struct InstagramView_Previews: PreviewProvider {
    
    static var previews: some View {
        let image = UIImage(named: "Photo")!
        let comment = "This spot is dope! Definitely coming back"
        StampImage(image: image, title: "The Big Duck", date: Date(), comment: comment)
            .previewLayout(.sizeThatFits)
    }
    
}

