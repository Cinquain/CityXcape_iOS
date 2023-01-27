//
//  GetStampButton.swift
//  CityXcape
//
//  Created by James Allan on 1/26/23.
//

import SwiftUI

struct GetStampButton: View {
    var body: some View {
        Text("Get Stamp")
            .foregroundColor(.black)
            .fontWeight(.thin)
            .font(.title3)
            .frame(width: 180, height: 45)
            .background(
                Capsule().fill(Color.cx_orange)
                    .overlay(
                        HStack {
                            Image("Stamp")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Image("Stamp")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 15)
                    )
            )
            .cornerRadius(25)
            .animation(.easeOut)
    }
}

struct GetStampButton_Previews: PreviewProvider {
    static var previews: some View {
        GetStampButton()
            .previewLayout(.sizeThatFits)
    }
}
