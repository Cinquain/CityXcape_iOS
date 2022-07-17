//
//  RowView.swift
//  CityXcape
//
//  Created by James Allan on 3/20/22.
//

import SwiftUI

struct RowView: View {
    let width: CGFloat = UIScreen.screenWidth * 0.90
    let height: CGFloat = 100
    
    let spot: SecretSpot
    let type: AnalyticsType
    var property: String {
        return type.rawValue
    }
    var count: Int {
        switch type {
        case .comments:
            return 0
        case .saves:
            return spot.saveCounts
        case .checkins:
            return spot.verifyCount
        case .views:
            return spot.viewCount
        }
    }
    
    var body: some View {
        HStack {
            SecretSpotView(width: 60, height: 60, imageUrl: spot.imageUrls.first ?? "")
                .padding(.leading, 5)
            
            Text(getCount())
                .fontWeight(.thin)
                .foregroundColor(.white)
            
            Spacer()

            Text(spot.spotName)
                .fontWeight(.thin)
                .foregroundColor(.white)
                .padding(.trailing, 5)
            
        }
        .frame(width: width, height: height)
        .background(Color.black)
        .cornerRadius(8)
    }
    
    fileprivate func getCount() -> String {
        switch type {
        case .comments:
            return ""
        case .saves:
            return count <= 1 ? "\(count) save" : "\(count) saves"
        case .checkins:
            return count <= 1 ? "\(count) checkin" : "\(count) checkins"
        case .views:
            return count <= 1 ? "\(count) view" : "\(count) views"
        }
    }
    
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        
        RowView(spot: SecretSpot.spot, type: .views)
    }
}
