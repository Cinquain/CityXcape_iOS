//
//  MissionDetails.swift
//  CityXcape
//
//  Created by James Allan on 10/2/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MissionDetails: View {
    
    @Environment(\.presentationMode) var presentationMode
    var captions: [String] = []
    
    init(mission: Mission) {
        self.mission = mission
        let name = "Mission is to \(mission.title)"
        let reward = "Reward is \(mission.bounty) StreetCred"
        let owner = "Posted by \(mission.owner)"
        
        captions.append(contentsOf: [name, reward, owner])
    }
    
    var mission: Mission
    
    
    var body: some View {
        VStack {
            Ticker(profileUrl: mission.ownerImageUrl, captions: captions)
                .padding(.top, 20)
                .frame(height: 100)

            
            WebImage(url: URL(string: mission.imageurl))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, 20)
            
            Text(mission.description)
                .multilineTextAlignment(.leading)
                .lineLimit(.none)
                .font(.body)
                .padding()
            
            HStack {
                Image("pin_blue")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                    .padding(.leading, 20)

                Text("Location:")
                Button(action: {
                    
                }, label: {
                    HStack {
    
                        Text(mission.region)
                        
                    }
                })
                Spacer()
            }
            
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                    .padding(.leading, 20)
                
                Text("Bouty:")
                Button(action: {
                    
                }, label: {
                    HStack {
                        
                        Text("\(mission.bounty) StreetCred")
                        
                    }
                })
                Spacer()
            }
            
            Spacer()
                .frame(height: 100)
            
            VStack(spacing: 20) {
                Button(action: {

                }, label: {
                    Text("Post Spot")
                        .padding()
                        .background(Color.cx_green)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                })
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Maybe later")
                        .foregroundColor(.red)
                })
            }
            
         
            
            Spacer()
            
        }
        .foregroundColor(.white)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MissionDetails_Previews: PreviewProvider {
    
    static let missionOne = Mission(title: "Post a Secret Spot", imageurl: "explore", description: "Help the scout community grow by posting a secret spot. Secret Spots are cool places not known by most people", world: "ScoutLife", region: "United States", bounty: 5, owner: "CityXcape", ownerImageUrl: "cx")
    
    static var previews: some View {
        MissionDetails(mission: missionOne )
    }
}
