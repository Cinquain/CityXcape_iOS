//
//  LikeAnimationView.swift
//  CityXcape
//
//  Created by James Allan on 8/29/21.
//

import SwiftUI

struct LikeAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        
        ZStack {
            Image(systemName: "heart.fill")
                .foregroundColor(.red.opacity(0.3))
                .font(.system(size: 200))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(animate ? 1.0 : 0.0)
            
            Image(systemName: "heart.fill")
                .foregroundColor(.red.opacity(0.3))
                .font(.system(size: 150))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(animate ? 1.0 : 0.0)
            
            Image(systemName: "heart.fill")
                .foregroundColor(.red.opacity(0.3))
                .font(.system(size: 100))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(animate ? 1.0 : 0.0)
            
        }
        .animation(Animation.linear(duration: 0.8).repeatForever())
        .onAppear(perform: {
            animate.toggle()
        })
    }
}

struct LikeAnimationView_Previews: PreviewProvider {
    
    @State static var animate: Bool = true
    static var previews: some View {
        LikeAnimationView(animate: $animate)
            .previewLayout(.sizeThatFits)
    }
}
