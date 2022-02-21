//
//  LikeAnimationView.swift
//  CityXcape
//
//  Created by James Allan on 8/29/21.
//

import SwiftUI

struct LikeAnimationView: View {
    
    @State private var animate: Bool = true
    @Binding var didLike: Bool {
        didSet {
            animate = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                animate = true
            }
        }
    }
    var size: CGFloat
    
    var body: some View {
        
        ZStack {
            Image(systemName: "heart.fill")
                .foregroundColor(didLike ? .red : .red.opacity(0.3))
                .font(.system(size: size))
                .scaleEffect(animate ? 1.0 : 0.0)
            
            Image(systemName: "heart.fill")
                .foregroundColor(didLike ? .red : .red.opacity(0.3))
                .font(.system(size: size * 0.50))
                .scaleEffect(animate ? 1.0 : 0.0)
            
            Image(systemName: "heart.fill")
                .foregroundColor(didLike ? .red : .red.opacity(0.3))
                .font(.system(size: size * 0.25 ))
                .scaleEffect(animate ? 1.0 : 0.0)
            
        }
        .animation(Animation.linear(duration: 0.5).repeatCount(1))
       
        
        
    }
}

struct LikeAnimationView_Previews: PreviewProvider {
    
    @State static var animate: Bool = false
    static var previews: some View {
        LikeAnimationView(didLike: $animate, size: 200)
            .previewLayout(.sizeThatFits)
    }
}
