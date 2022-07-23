//
//  FeedBubbleView.swift
//  CityXcape
//
//  Created by James Allan on 7/18/22.
//

import SwiftUI

struct FeedBubbleView: View {
    
    var feed: Feed
    var vm: FeedViewModel
    
    var width: CGFloat = UIScreen.screenWidth
    @State private var showPass: Bool = false
    
    var body: some View {
 
            HStack(spacing: 4) {
                userButton
                buttonContent
                Spacer()
              
            }
            .background(Color.black.opacity(0.5))
            .cornerRadius(12)
            

    }
}


extension FeedBubbleView {
    
    private var buttonContent: some View {
        Button {
            //TBD
        } label: {
          
            vm.calculateView(feed: feed)
                .fontWeight(.thin)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
            
        }

    }
    
    private var stamp: some View {
        Image("Stamp")
            .resizable()
            .scaledToFit()
            .frame(height: 40)
            .padding(.leading, 20)
    }
    
    private var userButton: some View {
        Button {
            showPass.toggle()
        } label: {
            UserDotView(imageUrl: feed.userImageUrl, width: 60)
        }
        .padding(.leading, 20)
        .sheet(isPresented: $showPass) {
            let user = User(feed: feed)
            PublicStreetPass(user: user)
        }
    }
    
    
}

struct FeedBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        FeedBubbleView(feed: Feed.feed, vm: FeedViewModel())
            .previewLayout(.sizeThatFits)
    }
}
