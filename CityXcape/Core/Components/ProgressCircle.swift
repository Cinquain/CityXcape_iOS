//
//  ProgressCircle.swift
//  CityXcape
//
//  Created by James Allan on 9/17/22.
//

import SwiftUI

struct ProgressCircle: View {
    
    let size: CGFloat
    @State var progress: CGFloat
    var rank: String
    @State private var fill: CGFloat = 0
    
    var body: some View {
        
        ZStack {
           
            Circle()
                .stroke(Color.dark_grey.opacity(0.6), style: StrokeStyle(lineWidth: 20))
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: fill)
                .stroke(Color.cx_orange, style: StrokeStyle(lineWidth: 20))
                .rotationEffect(.init(degrees: -90))
                .animation(.easeIn(duration: 3), value: fill)
                .frame(width: size, height: size)
            
            VStack(spacing: 0) {
                Image(rank)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size / 4)
                    
                Text(rank)
                    .fontWeight(.thin)
                    .font(.caption)
                
            }.foregroundColor(.white)

        }
        .onAppear {
            self.fill = progress
        }
        
        
    }
}

struct ProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircle(size: 300, progress: 0.5, rank: "Scout")
            .previewLayout(.sizeThatFits)
    }
}
