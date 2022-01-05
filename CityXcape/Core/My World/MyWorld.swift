//
//  MyJourney.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI
import CoreLocation
import Combine
import Shimmer
import JGProgressHUD_SwiftUI

struct MyWorld: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var username: String?

    @StateObject var vm = MyWorldViewModel()
  
    @State private var currentIndex = 0
    @State private var isPresented: Bool = false
    @Binding var selectedTab: Int


    @State var captions: [String] = [
        "CityXcape",
        "You got Spots to Visit",
        "Your World"
    ]
    
    var body: some View {
        
   
        
            GeometryReader { geo in
                
                ZStack {
                    Color.background
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Ticker(profileUrl: profileUrl ?? "", captions: $captions)
                            .frame(height: 100)
                        
                        
                    if vm.showOnboarding {
                        
                        
                        Image("marker")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                        
                        Text("Start building your world by adding \n a spot you want to visit ")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.thin)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            selectedTab = 2
                        } label: {
                            Text("Post a Spot")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                        .foregroundColor(.black)
                        .padding(.top, 40)
                        .shimmering(duration: 4)


                        Spacer()
                    } else {
                            ScrollView {
                                VStack(spacing: 25) {
                                    ForEach(vm.secretspots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser}), id: \.postId) { spot in
                                        
                                        PreviewCard(spot: spot)
                                            .onTapGesture(perform: {
                                                guard let index = self.vm.secretspots.firstIndex(of: spot) else {return}
                                                self.currentIndex = index
                                                isPresented.toggle()
                                            })
                                    
                                        Divider()
                                    }
                                }
                                
                            }
                            .colorScheme(.dark)
                        
                    }
                        
                        
                        
                    }
                        
                }
            }
            .sheet(isPresented: $isPresented, onDismiss: {
                currentIndex = 0
            } ,content: {
        
                if let spot = vm.secretspots[currentIndex] {
                    SpotDetailsView(spot: spot, index: $currentIndex)
                }
                
            })
            .onAppear {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    guard let streetname = username else {return}
                    let count = vm.secretspots.count
                    let countStatement = "You got \(count) spots to visit"
                    let worldStatement = "\(streetname)'s World"
                    
                    captions[1] = countStatement
                    captions[2] = worldStatement
                }
              
            }
     
    }
    
    
  
}

struct MyJourney_Previews: PreviewProvider {
    @State static var selection: Int = 0

    static var previews: some View {
        MyWorld(selectedTab: $selection)
    }
}
