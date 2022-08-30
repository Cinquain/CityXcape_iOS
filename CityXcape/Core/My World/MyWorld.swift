//
//  MyJourney.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI
import CoreLocation
import Combine

struct MyWorld: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var username: String?

    @StateObject var vm = MyWorldViewModel()
    @State private var isPresented: Bool = false
    @Binding var selectedTab: Int
    @State var currentSpot: SecretSpot?
    @State private var showMission: Bool = false


    let manager = CoreDataManager.instance

    var body: some View {
   
            NavigationView {
                            
                ScrollView {
                        
                        if vm.showOnboarding {
                            confusedPin
                           
                            discoverButton

                            Spacer()
                          
                        }  else {
                            
                            if vm.showSearch {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    TextField("Search a spot", text: $vm.searchTerm) {
                                        vm.performSearch()
                                    }
                                    .frame(width: UIScreen.screenWidth - 100, height: 45)
                                    .padding(.horizontal, 10)
                                    .overlay(
                                          RoundedRectangle(cornerRadius: 20)
                                            .stroke(.white, lineWidth: 0.5)
                                      )
                                    .animation(.easeIn(duration: 0.5), value: vm.showSearch)
                                    .offset(y: -15)
                                }
                            }
                                                    
                            LazyVStack(spacing: 5) {
                                ForEach(vm.currentSpots, id: \.id) { spot in
                                    
                                    VStack {

                                        PreviewCard(spot: spot)
                                            .onTapGesture(perform: {
                                                
                                                self.currentSpot = spot
                                                AnalyticsService.instance.viewedSecretSpot()
                                            })
                                            .sheet(item: $currentSpot) {
                                                //Dismiss Code
                                            } content: { spot in
                                                SpotDetailsView(spot: spot)
                                            }

                                    }
                                    
                                 //End of VStack
                                    Divider()
                                }
                                
                                
                            }
                        }
                        
                        
                        //End of Scrollview
                    }
                    .navigationBarItems(leading: toggleButton, trailing: searchButton)
                    .toolbar {
                       ToolbarItem(placement: .principal) {
                           tabIcon
                       }
                    }
                    .colorScheme(.dark)
                    .tint(.white)
                    .background(Color.background.edgesIgnoringSafeArea(.all))
                    .onAppear {
                        manager.fetchSecretSpots()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            vm.fetchSecretSpots()
                        }
                    }
         
                      
                
             
                //End of Navigation View
            }

           
            
        
        //End of body
    }
    

    
  
}

extension MyWorld {
    
    private var confusedPin: some View {
        VStack {
            Image("marker")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
            
            Text("Start building your world by saving \n spots you want to visit ")
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
        }
    }
    
    private var discoverButton: some View {
        Button {
            selectedTab = 1
        } label: {
            Text("Find Spots")
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(5)
        }
        .padding(.top, 40)

    }
    
    private var tabIcon: some View {
        VStack(spacing: 0) {
            Image("logo")
                .resizable()
                .scaledToFit()
            .frame(height: 25)
            Text(getMessage())
                .fontWeight(.thin)
                .foregroundColor(.white)
                .font(.caption)
        }
    }
    
    private var searchButton: some View {
        Button {
            vm.showSearch.toggle()
        } label: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
        }

    }
    
    private var toggleButton: some View {
        
        Button {
            vm.showVisited.toggle()
        } label: {
            Image(systemName: "checkmark.seal")
                .resizable()
                .scaledToFit()
                .font(.title2)
                .opacity(0.7)
        }
    }
    
    
    fileprivate func getMessage() -> String {
        if vm.showVisited {
            return "\(vm.allSpots.filter({$0.verified == true}).count) spots visited"
        } else {
            return "\(vm.allSpots.filter({$0.verified == false}).count) spots to visit"
        }
    }
    
    
}

struct MyJourney_Previews: PreviewProvider {
    @State static var selection: Int = 0

    static var previews: some View {
        MyWorld(selectedTab: $selection)
    }
}
