//
//  SettingsRowView.swift
//  CityXcape
//
//  Created by James Allan on 8/24/21.
//

import SwiftUI

struct SettingsRowView: View {
    
    var text: String
    var leftIcon: String
    var color: Color
    
    var body: some View {
        
        HStack {
            
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                
                Image(systemName: leftIcon)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(text)
                .foregroundColor(.black)
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundColor(.black)
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(text: "Row Title", leftIcon: "heart.fill", color: .red)
            .previewLayout(.sizeThatFits)
    }
}
