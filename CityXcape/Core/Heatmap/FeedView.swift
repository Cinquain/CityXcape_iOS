//
//  Feed.swift
//  CityXcape
//
//  Created by James Allan on 7/17/22.
//

import SwiftUI
import Shimmer

struct FeedView: View {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?

    @StateObject var discoverVM: DiscoverViewModel
    @StateObject var vm: FeedViewModel
    
    var body: some View {

        
        VStack(spacing:0) {
            cityTitle
            ScrollView {
             
                ForEach(vm.feeds) { feed in
                    FeedBubbleView(feed: feed, vm: vm)
                        .padding(.top, 10)
                }
                
            }
            commentField
                .opacity(0.8)
                .sheet(item: $vm.secretSpot) { spot in
                    SecretSpotPage(spot: spot, vm: discoverVM)
                }
               
            
        }
        .background(
            ZStack {
                Color.black
                Image("orange-paths")
                    .resizable()
                    .scaledToFit()
                    .frame(height: UIScreen.screenHeight)
                    .shimmering(active: true, duration: 3, bounce: true)
            }
            .edgesIgnoringSafeArea(.all)
            .zIndex(-100)
                
        )
     
        //Body
    }
}

extension FeedView {
    
    private var cityTitle: some View {
        HStack {
            Text("City Real Time")
                .font(.title)
                .fontWeight(.thin)
            Image("grid")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
              
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .foregroundColor(.white)
    }
    
    
    private var streetBackground: some View {
        Image("colored-paths")
            .resizable()
            .scaledToFit()
            .frame(height: UIScreen.screenHeight)
            .clipped()
            .opacity(0.7)
          
    }
    
    private var commentField: some View {
        HStack {
            UserDotView(imageUrl: profileUrl ?? "", width: 30)
               
            TextField("Broadcast a message", text: $vm.submissionText)
                .placeholder(when: vm.submissionText.isEmpty) {
                    Text("Broadcast a message").foregroundColor(.gray)
            }
            .padding()
            
            
            Button {
                vm.postMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .renderingMode(.template)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .alert(isPresented: $vm.showAlert) {
                return Alert(title: Text(vm.alertMessage))
            }

        }
        .padding(.horizontal, 20)
    }
    
}

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(discoverVM: DiscoverViewModel(), vm: FeedViewModel())
    }
}
