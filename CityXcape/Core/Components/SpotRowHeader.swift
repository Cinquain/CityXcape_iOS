//
//  SpotRowHeader.swift
//  CityXcape
//
//  Created by James Allan on 8/18/21.
//

import SwiftUI

struct SpotRowHeader: View {
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {

            HStack {
                
                Text(Labels.headerPhoto.rawValue)
                    .frame(width: width / 4.5)
                
                Spacer()
                
                HStack {
                    Text(Labels.headerName.rawValue)
                    Spacer()
                }
                .frame(width: width / 2.5)
                .padding(.leading, 20)
                
                HStack {
                    Text(Labels.headerDistance.rawValue)
                    Spacer()
                }
                .frame(width: width / 4)
            }
            .frame(width: .infinity, height: 30)
            .padding()
            .foregroundColor(.accent)

    }
}

struct SpotRowHeader_Previews: PreviewProvider {
    static var previews: some View {
        SpotRowHeader()
    }
}
