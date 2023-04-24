//
//  SpotSelectionList.swift
//  CityXcape
//
//  Created by James Allan on 6/20/22.
//

import SwiftUI

struct SpotSelectionList: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: PostTrailViewModel
    @State private var currentSpot: SecretSpot?
    
    var body: some View {
        VStack {
        
            HStack {
                Text(vm.allspots.count > 0 ? "Select spots to add" : "You have no spots!")
                    .font(.title)
                    .fontWeight(.thin)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                }
            }
            .foregroundColor(.white)
            .padding()
            
            ScrollView {
                ForEach(vm.allspots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser})) { spot in
                    Button {
                        currentSpot = spot
                        if let selectedSpot = currentSpot {
                            vm.selectedSpots.append(selectedSpot)
                        }
                        vm.showAlert.toggle()
                    } label: {
                        SpotRowView(imageUrl: spot.imageUrls.first ?? "", name: spot.spotName, distance: spot.distanceFromUser)
                    }
                    .alert(isPresented: $vm.showAlert) {
                        return Alert(title: Text("Spot added!"))
                    }
                }
            }
            
        }
        .background(Color.black)
    }
}

struct SpotSelectionList_Previews: PreviewProvider {
    static var previews: some View {
        SpotSelectionList(vm: PostTrailViewModel())
    }
}
