//
//  MissionRowView.swift
//  CityXcape
//
//  Created by James Allan on 10/2/21.
//

import SwiftUI

struct MissionRowView: View {
    
    var name: String
    var bounty: Int
    
    var body: some View {
        HStack {
            Text(name)

            Spacer()
            
            Text("\(bounty) StreetCred")
                .padding()
                
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.black)
    }
}

struct MissionRowView_Previews: PreviewProvider {
    static var previews: some View {
        MissionRowView(name: "Find Spot", bounty: 1)
            .previewLayout(.sizeThatFits)
    }
}
