//
//  MyTrailsView.swift
//  CityXcape
//
//  Created by James Allan on 4/3/23.
//

import SwiftUI
import Shimmer
import AVFoundation

struct MyTrailsView: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @Environment(\.dismiss) private var dismiss

    @State var trails: [Trail] = []
    @State private var currentTrail: Trail?
    @State private var showNewTrails: Bool = false
    @State var spots: [SecretSpot] = []
    var body: some View {
        NavigationView {
            
            ScrollView {
                if trails.isEmpty {
                    VStack {
                        Spacer()
                            .frame(height: 100)
                        Text("Nothing Saved!")
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        
                        
                        Button {
                            showNewTrails.toggle()
                        } label: {
                            VStack {
                                Image("trail")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 140)
                                Text("Discover Trails")
                                    .font(.title)
                                    .fontWeight(.light)
                            }
                            .opacity(0.80)
                        }
                        .padding(.top, 10)
                       
                    }
                    
                } else {
                    ForEach(trails) { trail in
                        VStack {
                            Button {
                                getAllSpots(trail) {
                                   currentTrail = trail
                                }
                            } label: {
                                TrailCardView(trail: trail)
                            }
                            .fullScreenCover(item: $currentTrail) { trail in
                                TrailDetailedView(spots: spots, trail: trail)
                            }
                        }
                       
                            
                    }
                }
             
            }
            .background(
                ZStack {
                    Color.black
                    Image("colored-paths")
                        .scaledToFit()
                        .opacity(0.5)
                        .shimmering(active: true,
                                    duration: 4,
                                    bounce: true)
                }
            )
            .navigationBarTitle(Text("My Trails"), displayMode: .inline)
            .toolbar {
                  ToolbarItem(placement: .navigationBarTrailing) {
                      Button {
                          dismiss()
                      } label: {
                          Image(systemName: "xmark.circle")
                      }

                  }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showNewTrails.toggle()
                    } label: {
                        Image(systemName: "globe")
                    }
                    .fullScreenCover(isPresented: $showNewTrails) {
                        DiscoverTrailsView()
                    }

                }
            }
        }
        .colorScheme(.dark)
        .onAppear {
            DataService.instance.getTrailForUser { result in
                switch result {
                    case .success(let trails):
                        self.trails = trails
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
     
       
     
      
        
    }
    
    func getAllSpots(_ trail: Trail, completion: @escaping () -> ()) {
            trail.spots.forEach { spotId in
                DataService.instance.getSpecificSpot(postId: spotId) { result in
                    switch result {
                        case .success(let spot):
                            spots.append(spot)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            }
            completion()
        }
    
}

struct MyTrailsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTrailsView()
    }
}
