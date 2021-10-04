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
    @StateObject var vm: MissionViewModel = MissionViewModel()

    var body: some View {
        
        let captions: [String] = [
            "Choose a Mission",
            "1 Mission pending",
            "Your Rank is Observer"
        ]
        
        VStack(spacing: 0) {
            
            Ticker(profileUrl: profileUrl ?? "", captions: captions)
                .padding(.top, 20)
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
                            self.isPresented.toggle()
                        }
                }
            }
            .listStyle(PlainListStyle())
            .colorScheme(.dark)

            Spacer()
                .frame(maxWidth: .infinity)
            
            
            
        }
        .foregroundColor(.white)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isPresented, content: {
            MissionDetails(mission: vm.standardMissions.first!)
        })
    }
}

struct MissionsView_Previews: PreviewProvider {
    static var previews: some View {
        MissionsView()
    }
}
