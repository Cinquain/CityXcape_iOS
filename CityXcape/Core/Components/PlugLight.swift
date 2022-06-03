//
//  PlugLight.swift
//  CityXcape
//
//  Created by James Allan on 6/2/22.
//

import SwiftUI

struct PlugLight: View {
    
    @Binding var on: Bool
    var handleButton: () -> ()
    let manager = SoundManager.instance
    var body: some View {
        
        Button {
            on.toggle()
            manager.playBeep()
            handleButton()
        } label: {
            Circle()
                .frame(width: 37, height: 37)
                .foregroundColor(
                    on ? .traffic_green
                    : .traffic_red)
                .shadow(color:
                    on ? .traffic_green
                    : .traffic_red, radius: 5)
                .animation(.easeOut(duration: 0.3), value: on)
        }
    }
}

struct PlugLight_Previews: PreviewProvider {
    
    @State static var constant: Bool = false
    static let someFunction: () -> () = {print("123")}

    static var previews: some View {
        PlugLight(on: $constant, handleButton: someFunction)
            .previewLayout(.sizeThatFits)
    }
    
}
