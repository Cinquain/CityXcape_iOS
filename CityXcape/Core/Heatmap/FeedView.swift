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
    @Binding var selectedTab: Int
    @StateObject var discoverVM: DiscoverViewModel
    @StateObject var vm: FeedViewModel
    @State private var showMenu: Bool = false
    let width: CGFloat = UIScreen.screenWidth
    
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
                    .alert(isPresented: $vm.showAlert) {
                        return Alert(title: Text(vm.alertMessage))
                    }
                
                GeometryReader { _ in
                    HStack {
                        SideMenu(selectedTab: $selectedTab, showMenu: $showMenu)
                            .offset(x: showMenu ? 0 : -width - 50)
                            .animation(.easeOut(duration: 0.3), value: showMenu)
                        
                        Spacer()
                    }
                }
                .background(Color.black.opacity(showMenu ? 0.5 : 0))
                .onTapGesture {
                    showMenu.toggle()
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
                       .opacity(vm.isSearching ? 1 : 0)
                       
                       
                       tabIcon
                        .opacity(vm.isSearching ? 0 : 1)

                   }
                   
               }
            }
            .navigationBarItems(leading: sandwichMenu, trailing: searchButton)
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
    
    private var sandwichMenu: some View {
        Button {
            showMenu.toggle()
        } label: {
            Image(systemName: showMenu ? "xmark" : "text.justify")
                .font(.title3)
                .foregroundColor(.white)
                .animation(.easeOut(duration: 0.3), value: showMenu)
        }
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
            vm.isSearching.toggle()
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
    @State static var number: Int = 1
    static var previews: some View {
        FeedView(selectedTab: $number, discoverVM: DiscoverViewModel(), vm: FeedViewModel())
            .colorScheme(.dark)
    }
}
