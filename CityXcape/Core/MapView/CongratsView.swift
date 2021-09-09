//
//  CongratsView.swift
//  CityXcape
//
//  Created by James Allan on 8/31/21.
//

import SwiftUI
import Shimmer

struct CongratsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                
               
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]), startPoint: .center, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                        .frame(maxHeight: geo.size.height / 6)
                    
                    Text("Congratulations!")
                        .font(.title)
                        .fontWeight(.thin)
                    
                    Image(Icon.pin.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width, height: geo.size.width / 1.8)
                        .shimmering()
                    
                    Text("You posted a Secret Spot")
                        .font(.caption)
                        .fontWeight(.thin)

                    Spacer()
                        .frame(maxHeight: geo.size.height / 9)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Image(Icon.check.rawValue)
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Done!")
                                .font(.caption)
                        }
                    })
                    .padding()
                    .frame(width: 150, height: 50)
                    .background(Color.black.opacity(0.9))
                    .foregroundColor(.blue)
                    .cornerRadius(5)
                    
                }
                .foregroundColor(.white)
                
            
                
            }
        }
     
    }
}

struct CongratsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratsView()
    }
}
