//
//  MissionRowHeader.swift
//  CityXcape
//
//  Created by James Allan on 10/2/21.
//

import SwiftUI

struct MissionRowHeader: View {
    var body: some View {
        HStack {
            
            Image("compass")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .frame(height: 25)
                .padding(.leading, 40)
            Text("Mission")
                .fontWeight(.thin)

            Spacer()
            
         
          
            Spacer()
                .frame(width: 50)
            Text("Bounty")
                .fontWeight(.thin)
            Image(systemName: "dollarsign.circle.fill")
                .padding(.trailing, 30)
            
            
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.black)
    }
}

struct MissionRowHeader_Previews: PreviewProvider {
    static var previews: some View {
        MissionRowHeader()
    }
}
