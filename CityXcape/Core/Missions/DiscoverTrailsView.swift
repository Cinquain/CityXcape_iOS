//
//  DiscoverTrailsView.swift
//  CityXcape
//
//  Created by James Allan on 4/5/23.
//

import SwiftUI
import Shimmer

struct DiscoverTrailsView: View {
    
    @State var trails: [Trail] = [Trail.demo, Trail.demo2]
    @Environment(\.dismiss) private var dismiss

    @State private var message: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            
            
            ScrollView {
                
                if trails.isEmpty {
                    emptyTrailsView()
                } else {
                    ForEach(trails) { trail in
                        NavigationLink {
                            SaveTrailView(trail: trail)
                        } label: {
                            TrailCardView(trail: trail)
                        }

                    }

                }
            }
            .navigationBarTitle(Text("Discover Trails").font(.title), displayMode: .inline)
            .toolbar {
                  ToolbarItem(placement: .navigationBarTrailing) {
                      Button {
                          dismiss()
                      } label: {
                          Image(systemName: "xmark.circle")
                      }
                  }
            }
        }
        .colorScheme(.dark)
        .background(
            ZStack {
                Color.black
                Image("colored-paths")
                    .scaledToFit()
                    .opacity(trails.isEmpty ? 0.2 : 0.5)
                    .shimmering(active: trails.isEmpty ? false : true,
                                duration: 4,
                                bounce: true)
            }
        )
        .onAppear {
            DataService.instance.getAllTrails { result in
                switch result {
                    case .success(let trails):
                        self.trails = trails
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
    
    @ViewBuilder
    func createHeader() -> some View {
        HStack {
            Image("trail")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text("New Trails")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.thin)
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func emptyTrailsView() -> some View {
        VStack {
            Text("No New Trails Found!")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.thin)
                .padding(.top, 50)
            
            Button {
                //
            } label: {
                VStack {
                    Image("pin_blue")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)

                    Text("Post One")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .shimmering(active: true, duration: 3)

                }
            }
        }
    }
    
    func saveTrail(trail: Trail) {
        DataService.instance.saveTrail2UserDB(trail: trail) { result in
            switch result {
            case .success(_):
              message = "Trail successfully saved!"
              showAlert.toggle()
            case .failure(let error):
                message = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
}

struct DiscoverTrailsView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverTrailsView()
    }
}
