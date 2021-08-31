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
                Spacer()
                Text(Labels.headerName.rawValue)
                    .frame(alignment: .center)
                    .padding(.leading, 40)
                Spacer()
                Text(Labels.headerDistance.rawValue)
                    .frame(width: width / 3.5, alignment: .center)
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
