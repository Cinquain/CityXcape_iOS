//
//  CheckinButton.swift
//  CityXcape
//
//  Created by James Allan on 2/22/22.
//

import SwiftUI

struct GetStampedButton: View {
    
    var height: Int
    var width: Int
    
    var body: some View {
        
        ZStack {
            Image("Stamp")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white.opacity(0.5))
                .frame(height: 50)
            
            Text("Get Stamped")
                .foregroundColor(.white)
                .font(.caption)
                .padding()
        }
        .frame(width: 200)
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
    }
}
