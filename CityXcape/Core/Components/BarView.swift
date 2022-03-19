//
//  BarView.swift
//  CityXcape
//
//  Created by James Allan on 3/18/22.
//

import SwiftUI

struct BarView: View {
    
    var progress: CGFloat
    @State private var value: CGFloat = 0
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: 200, height: 30)
                    .foregroundColor(.dark_grey)
                
                Capsule()
                    .frame(width: value, height: 30)
                    .foregroundColor(.cx_orange.opacity(0.8))
                    .animation(Animation.linear(duration: 0.5))
                
            }
        }
        .onAppear {
            value = progress
        }
    }

}

struct BarView_Previews: PreviewProvider {
    
    static var previews: some View {
        BarView(progress: 100)
            .previewLayout(.sizeThatFits)
    }
}
