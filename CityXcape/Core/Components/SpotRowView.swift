//
//  SpotRowView.swift
//  CityXcape
//
//  Created by James Allan on 8/18/21.
//

import SwiftUI

struct SpotRowView: View {
    let width = UIScreen.main.bounds.width
    let imageUrl: String
    let name: String
    let distance: Double
    let size: CGFloat = 80
    
    var body: some View {
        
        HStack {
            
            SecretSpotView(width: size, height: size, imageUrl: imageUrl)
            
            
            HStack {
                Text(name)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.leading, 20)
            .frame(maxWidth: width / 2)

            
            Spacer()
            
            HStack {
                Text(returnDistance())
                Spacer()
            }
            .frame(width: width / 4)
            
        }
        .frame(height: 80)
        .padding()
    }
    
    fileprivate func returnDistance() -> String {
        if distance < 1 {
            return String(format: "%.1f mile", distance)
        } else {
            return String(format: "%.1f miles", distance)
        }
    }
    
}

struct SpotRowView_Previews: PreviewProvider {
    static var previews: some View {
        
      
        SpotRowView(imageUrl: "donut", name: "The Big Duck", distance: 10)
    }
}
