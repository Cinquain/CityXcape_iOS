//
//  SpotListView.swift
//  CityXcape
//
//  Created by James Allan on 6/18/22.
//

import SwiftUI

struct SpotListView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: PostTrailViewModel
    @State private var showAlert: Bool = false
    var body: some View {
        
        NavigationView {
            List {
                ForEach(vm.selectedSpots) { spot in
                    HStack {
                        SecretSpotView(width: 50, height: 50, imageUrl: spot.imageUrls.first ?? "")
                        Text(spot.spotName)
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
                
              
            }
            .navigationBarTitle("Spot List", displayMode: .inline)
            .navigationBarItems(leading: exitButton, trailing: addButton)
            
         
            
        }
        .colorScheme(.dark)

        //End of body
    }
    
    
    
}


extension SpotListView {
    
    private var addButton: some View {
        Button {
            vm.showAllSpots.toggle()
        } label: {
            Text("Add")
        }
        .sheet(isPresented: $vm.showAllSpots) {
            SpotSelectionList(vm: vm)
        }

    }
    
    fileprivate func delete(index: IndexSet) {
        vm.selectedSpots.remove(atOffsets: index)
    }
    
    fileprivate func move(index: IndexSet, newOffset: Int ) {
        vm.selectedSpots.move(fromOffsets: index, toOffset: newOffset)
    }
    
    private var exitButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Done")
                
        }
    }
    
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListView()
            .environmentObject(PostTrailViewModel())
    }
}
