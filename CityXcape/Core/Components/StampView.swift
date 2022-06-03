//
//  StampView.swift
//  CityXcape
//
//  Created by James Allan on 2/19/22.
//

import SwiftUI

struct StampView: View {
    
    var spot: SecretSpot
    var date = Date.formattedDate(Date())
    var hour = Date.timeFormatter(Date())
    
    @State private var animate: Bool = true
    
    var body: some View {
        
        
        VStack {
            Image("Stamp")
                .resizable()
                .scaledToFit()
                .frame(width: 325)
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        
                        Text("\(spot.spotName)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.stamp_red)
                        
                        Text("\(date())")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.stamp_red)
                        
                        Text("\(hour())")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.stamp_red)
                        
                    }
                    .rotationEffect(Angle(degrees: -32))
                    )
                .rotationEffect(animate ? Angle(degrees: 0) : Angle(degrees: -45))
                .scaleEffect(animate ? 4 : 1)
                .animation(.easeIn(duration: 0.4))
                .animation(.spring())
        }
        .onAppear {
            SoundManager.instance.playStamp()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animate = false
            }
            
        }
        
    }
}




struct StampView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        StampView(spot: SecretSpot.spot)
    }
}
