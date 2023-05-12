//
//  FeedBubbleView.swift
//  CityXcape
//
//  Created by James Allan on 7/18/22.
//

import SwiftUI

struct FeedBubbleView: View {
    @EnvironmentObject var vm: FeedViewModel
    var feed: Feed
    
    var width: CGFloat = UIScreen.screenWidth
    
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
            vm.calculateAction(feed: feed)
        } label: {
            vm.calculateView(feed: feed)
                .fontWeight(.thin)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
        }
        .sheet(item: $vm.user) { user in
            PublicStreetPass(user: user)
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
            vm.user = User(feed: feed)
        } label: {
            UserDotView(imageUrl: feed.userImageUrl, width: 60)
        }
        .padding(.leading, 20)
        .fullScreenCover(item: $vm.verification) { verification in
            PublicStampView(verification: verification)
        }

    }
    
    
}

struct FeedBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        FeedBubbleView(feed: Feed.feed)
            .previewLayout(.sizeThatFits)
            .environmentObject(FeedViewModel())
    }
}
