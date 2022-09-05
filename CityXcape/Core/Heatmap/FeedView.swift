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

        NavigationView {
            ZStack {
                
                ScrollView {
                 
                    ForEach(vm.feeds) { feed in
                        FeedBubbleView(feed: feed, vm: vm)
                            .padding(.top, 10)
                            .sheet(item: $vm.secretSpot) { spot in
                                SecretSpotPage(spot: spot, vm: discoverVM)
                            }
                        }
                    
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
                .edgesIgnoringSafeArea(.bottom)
                .zIndex(-100)
                    
            )
            .toolbar {
               ToolbarItem(placement: .principal) {
                   ZStack {
                       Ticker(searchText: $vm.submissionText, handlesearch: {
                           vm.performSearch()
                       }, width: UIScreen.screenWidth, searchTerm: vm.searchTerm)
                       .frame(width: UIScreen.screenWidth / 2 )
                       .opacity(vm.searchUser ? 1 : 0)
                       
                       
                       tabIcon
                        .opacity(vm.searchUser ? 0 : 1)

                   }
                   
               }
            }
            .navigationBarItems(leading: heatMap, trailing: searchButton)
            .colorScheme(.dark)
            //End of Navigation view
        }
        .sheet(isPresented: $vm.showListView) {
            UsersListView(users: vm.users)
        }
     
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
    
    private var tabIcon: some View {
        VStack(spacing: 0) {
            Image("logo")
                .resizable()
                .scaledToFit()
            .frame(height: 25)
            Text("City Real Time")
                .fontWeight(.thin)
                .foregroundColor(.white)
                .font(.caption)
        }
    }
    
    
    private var searchButton: some View {
        Button {
            vm.searchUser.toggle()
        } label: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
        }

    }
    
    private var heatMap: some View {
        Button {
            vm.showHeatmap.toggle()
        } label: {
            Image("grid")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
        }

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
            .colorScheme(.dark)
    }
}
