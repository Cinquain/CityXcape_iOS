//
//  CheckinButton.swift
//  CityXcape
//
//  Created by James Allan on 2/22/22.
//

import SwiftUI

struct GetStampedButton: View {
    
    var height: CGFloat
    var width: CGFloat
    
    var body: some View {
        
        ZStack {
            Image("Stamp")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(.white.opacity(0.5))
                .frame(height: height)
                .rotationEffect(Angle(degrees: 32))
            
            Text("Get Stamped")
                .foregroundColor(.white)
                .fontWeight(.thin)
                .font(.caption)
                .padding()
        }
        .frame(width: width)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white, lineWidth: 1)
        )

        
    }
}

struct CheckinButton_Previews: PreviewProvider {
    static var previews: some View {
        GetStampedButton(height: 60, width: 200)
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
    }
}
