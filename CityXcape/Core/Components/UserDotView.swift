//
//  UserDotView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserDotView: View {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?

    let imageUrl: String
    let width: CGFloat

    let ratio : CGFloat = 1.3
    @State var userProfileImage = UIImage()
    
    var body: some View {
        
        ZStack {
            Image(Icon.dot.rawValue)
                .resizable()
                .frame(width: width, height: width, alignment: .center)
                .overlay(
                    WebImage(url: URL(string: imageUrl))
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: width / ratio, height: width / ratio)
                    
                )
            
        }
    }
    
    fileprivate func getProfileImage() {
        if let uid = userId {
            ImageManager.instance.downloadProfileImage(userId: uid) { profileImage in
                if let image = profileImage {
                    userProfileImage = image
                } else {
                    print("Profile Image is Nil")
                }
            }
        }
       
    }
}

struct UserDotView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        
        UserDotView(imageUrl: "User", width: 150)
    }
}
