//
//  TrailDetailedView.swift
//  CityXcape
//
//  Created by James Allan on 4/9/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TrailDetailedView: View {
    @Environment(\.dismiss) private var dismiss
    var spots: [SecretSpot]
    var trail: Trail
    
    @State private var item: SelectedBar = .spots
    @State private var completedSpots: [SecretSpot] = []
    @State private var incompleteSpots: [SecretSpot] = []
    @State private var currentSpot: SecretSpot?
    let manager = CoreDataManager.instance
    @State var verifications: [String] = CoreDataManager
                                            .instance
                                            .verifications
                                            .map({Verification(entity: $0)})
                                            .map({$0.id})
    
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Flavor", selection: $item) {
                    ForEach(SelectedBar.allCases) { item in
                        Text(item.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                    switch item {
                        case .map:
                            Heatmap(secretspots: incompleteSpots)
                                .colorScheme(.dark)
                        case .spots:
                            if incompleteSpots.isEmpty {
                                ZStack {
                                    AnimationView()
                                    VStack {
                                        Spacer()
                                        Image("trail_completed")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 300)
                                        Spacer()
                                    }
                                }
                            } else {
                                showSpots()
                            }
                        case .completed:
                            showStamps()
                    }
                
                
                Spacer()
            }
            .navigationBarTitle(Text(trail.name).font(.title), displayMode: .inline)
            .toolbar {
                  ToolbarItem(placement: .navigationBarLeading) {
                      Button {
                          dismiss()
                      } label: {
                          Image(systemName: "xmark.circle")
                      }

                  }
            }
        }
        .onAppear(perform: {
            filterspots()
        })
        .colorScheme(.dark)
        
    }
    
    
    @ViewBuilder
    fileprivate func spotItem(spot: SecretSpot, stamped: Bool) -> some View {
        HStack(spacing: 80) {
            WebImage(url: URL(string: spot.imageUrls.first ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .cornerRadius(10)
                .overlay {
                    if stamped {
                        Image("Stamp")
                            .resizable()
                            .scaledToFit()
                    }
                }

            
            VStack(alignment: .leading) {
                HStack {
                    Image("pin_blue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    Text(spot.spotName)
                        .font(.title2)
                        .fontWeight(.thin)
                        .lineLimit(1)
                }
                
                Text(spot.description ?? "")
                    .font(.caption)
                    .fontWeight(.thin)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(width: 300)
            }
            .frame(maxWidth: 200)
        }
    }
    
    @ViewBuilder
    fileprivate func showStamps() -> some View {
        if completedSpots.isEmpty {
            VStack {
                Spacer().frame(height: 150)
                Image("nothing")
                    .resizable()
                    .scaledToFit()
                .frame(height: 300)
            }
        } else {
            ScrollView {
                ScrollView {
                ForEach(completedSpots) { spot in
                        Spacer()
                            .frame(height: 20)
                         
                        Button {
                            currentSpot = spot
                        } label: {
                            spotItem(spot: spot, stamped: true)
                        }
                        .sheet(item: $currentSpot, onDismiss: {
                            manager.fetchVerifications()
                            verifications = manager
                                                .verifications
                                                .map({Verification(entity: $0)})
                                                .map({$0.id})
                            
                        }) { spot in
                            SpotDetailsView(spot: spot)
                        }
                }
            }
            }
        }
    }
    
    @ViewBuilder
    fileprivate func showSpots() -> some View {
        ScrollView {
        ForEach(incompleteSpots) { spot in
                Spacer()
                    .frame(height: 20)
                 
                Button {
                    currentSpot = spot
                } label: {
                    spotItem(spot: spot, stamped: false)
                }
                .sheet(item: $currentSpot) { spot in
                    SpotDetailsView(spot: spot)
                }
        }
      }
    }
    
    fileprivate func filterspots() {
        incompleteSpots = spots.filter({!verifications.contains($0.id)})
        completedSpots = spots.filter({verifications.contains($0.id)})
    }
    
}

struct TrailDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        TrailDetailedView(spots: [SecretSpot.spot, SecretSpot.spot2, SecretSpot.spot3], trail: Trail.demo)
    }
}
