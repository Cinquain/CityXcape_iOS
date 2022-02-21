//
//  StampView.swift
//  CityXcape
//
//  Created by James Allan on 2/19/22.
//

import SwiftUI

struct StampView: View {
    
    private var color: Color = Color.random
    
    var body: some View {
        
        
        VStack {
            Image("Stamp")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(color)
                .frame(width: 300)
                .rotationEffect(Angle(degrees: -45))
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        Text("Jan 21 2022")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(color)
                        
                        Text("The Big Duck")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(color)
                    }
                    .rotationEffect(Angle(degrees: -45))


                )
        }
        
    }
}

struct StampView_Previews: PreviewProvider {
    static var previews: some View {
        StampView()
    }
}
