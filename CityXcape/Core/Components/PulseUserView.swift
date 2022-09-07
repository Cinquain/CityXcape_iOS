//
//  PulseUserView.swift
//  CityXcape
//
//  Created by James Allan on 9/7/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PulseUserView: View {
    
    @State private var animate: Bool = false
    var imageUrl: String
    var width: CGFloat
    
    var body: some View {
        ZStack {
            

            Circle()
                .fill(Color.cx_orange.opacity(0.45))
                .frame(width: width + 40, height: width + 40)

            Circle()
                .fill(Color.cx_orange.opacity(0.35))
                .frame(width: width + 100, height: width + 100)
                .scaleEffect(self.animate ? 1 : 0)
        }
        .onAppear {
            self.animate.toggle()
        }
        .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: true))
        .overlay {
            WebImage(url: URL(string: imageUrl))
                .resizable()
                .clipShape(Circle())
                .frame(width: width - 10, height: width - 10)
        }
    }
}

struct PulseUserView_Previews: PreviewProvider {
    static var previews: some View {
        PulseUserView(imageUrl: "https://pics.filmaffinity.com/White_Chicks-973832641-large.jpg", width: 100)
            .previewLayout(.sizeThatFits)
    }
}
