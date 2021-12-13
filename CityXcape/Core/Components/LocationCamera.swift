//
//  LocationCamera.swift
//  CityXcape
//
//  Created by James Allan on 12/7/21.
//

import SwiftUI

struct LocationCamera: View {
    
    var height: CGFloat
    var color: Color
    
    var body: some View {
        ZStack {
            Image("pin_blue")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: height)
            
            
            Image(systemName: "camera.shutter.button.fill")
                .font(.system(size: height / 4.5))
                .foregroundColor(color)
                .padding(.bottom, 20)
        }
    }
}

struct LocationCamera_Previews: PreviewProvider {
    
    static var previews: some View {
        LocationCamera(height: 100, color: .black)
    }

}

