//
//  AnalyticsView.swift
//  CityXcape
//
//  Created by James Allan on 3/20/22.
//

import SwiftUI

struct AnalyticsView: View {
    
    var type: AnalyticsType
    var property: String {
        return type.rawValue
    }
    
    var body: some View {
        
        VStack {
            HStack {
               
                Image("pin_blue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                
                VStack {
                    Text("Total \(property)")
                        .font(.title)
                        .fontWeight(.thin)
                }
                .foregroundColor(.white)

                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            
            ScrollView {
                ForEach(0..<5) { num in
                    
                }
            }
            
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: .black, location: 0.40),
            Gradient.Stop(color: .cx_orange, location: 3.0),
        ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(type: .comments)
    }
}
