//
//  MissionsView.swift
//  CityXcape
//
//  Created by James Allan on 10/2/21.
//

import SwiftUI

struct MissionsView: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @State private var isPresented: Bool = false
    @State private var mission: Mission?
    @State private var currentIndex: Int = 0
    @Binding var selectedTab: Int 
    @StateObject var vm: MissionViewModel = MissionViewModel()
    
    var body: some View {
        
        let captions: [String] = [
            "Missions are exploration jobs",
            "1 Mission pending",
            "Choose a Mission"
        ]
        
        VStack(spacing: 0) {
            
            Ticker(profileUrl: profileUrl ?? "", captions: captions)
                .padding(.top, 50)
                .frame(height: 100)
            
            Image("Scout")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 100)
                .opacity(0.1)
                .padding(.top)
            
           
            MissionRowHeader()
                .padding(.top, 10)
            
            List {
                ForEach(vm.standardMissions, id: \.self) { mission in 
                    MissionRowView(name: mission.title, bounty: mission.bounty)
                        .onTapGesture {
                            guard let index = vm.standardMissions.firstIndex(of: mission)
                            else {return}
                            self.currentIndex = index
                            self.mission = mission
                            AnalyticsService.instance.viewedMission()
                            self.isPresented.toggle()
                        }
                }
            }
            .listStyle(PlainListStyle())
            .colorScheme(.dark)
            
            Button {
                vm.refreshSecretSpots()
                AnalyticsService.instance.loadedNewSpots()
            } label: {
                VStack {
                    Image(Icon.refresh.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                    Text("Load New Spots")
                        .font(.caption)
                        .fontWeight(.light)
                }
            }

            Spacer()
                .frame(maxWidth: .infinity)
            
            
            
        }
        .foregroundColor(.white)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $isPresented, content: {
            
            if let mission = vm.standardMissions[currentIndex] {
                MissionDetails(mission: mission, parent: self)
            }
        })
        .fullScreenCover(isPresented: $vm.hasNewSpots, onDismiss: {
            selectedTab = 0
        }, content: {
            SwipeView(vm: vm)
        })
        .alert(isPresented: $vm.showAlert) {
            return Alert(title: Text("No new spot recently posted 😭"))
        }
    }
}

struct MissionsView_Previews: PreviewProvider {
    @State static var selection: Int = 0
    static var previews: some View {
        MissionsView(selectedTab: $selection)
    }
}
