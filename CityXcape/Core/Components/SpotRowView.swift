//
//  SpotRowView.swift
//  CityXcape
//
//  Created by James Allan on 8/18/21.
//

import SwiftUI

struct SpotRowView: View {
    let width = UIScreen.main.bounds.width
    let image: Image
    let name: String
    let distance: CGFloat
    let size: CGFloat = 80
    
    var body: some View {
        HStack {
            
            SecretSpotView(width: size, height: size, image: image)
            
            Spacer()
            
            Text(name)
            
            Spacer()
    
            Text(returnDistance())
        }
        .frame(width: .infinity, height: 80)
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
        
        let donut = Image("donut")
        SpotRowView(image: donut, name: "The Big Duck", distance: 10)
    }
}
