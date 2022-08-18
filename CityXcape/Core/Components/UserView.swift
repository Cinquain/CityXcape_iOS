//
//  UserView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/22.
//

import SwiftUI

struct UserView: View {
    var user: User
    
    var body: some View {
        HStack {
            UserDotView(imageUrl: user.profileImageUrl, width: 60)
                
            VStack(alignment: .leading) {
                Text(user.displayName)
                    .fontWeight(.thin)
                Text(user.bio ?? "")
                    .font(.caption)
                    .fontWeight(.thin)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Friends Since")
                    .font(.caption)
                    .fontWeight(.thin)
                Text(user.membership?.timeFormatter() ?? Date().timeFormatter())
                    .fontWeight(.thin)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User())
            .previewLayout(.sizeThatFits)
    }
}
