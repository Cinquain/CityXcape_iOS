//
//  EditMap.swift
//  CityXcape
//
//  Created by James Allan on 7/6/22.
//

import SwiftUI
import MapKit
import UIKit

struct EditMap: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var mapItem: MKMapItem
    @State var isHunt: Bool = false
    
    @ObservedObject var vm = MapSearchViewModel()
    
    var body: some View {
        
        ZStack(alignment: .top) {
            MainMapView(viewModel: vm)
                
            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    TextField("Search Location", text: $vm.searchQuery, onCommit: {
                        UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.endEditing(true)

                    })
                        .placeholder(when: vm.searchQuery.isEmpty) {
                            Text("Search address or tap to drop pin").foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(3)
                    .foregroundColor(.black)
                    .accentColor(.black)
                }
                .padding()
                .padding(.vertical,20)
                .foregroundColor(.black)
                
                
                ScrollView(.vertical) {
                    VStack(spacing: 16) {
                        
                        ForEach(vm.mapItems, id: \.self) { mapItem in
                            
                            Button(action: {
                                self.mapItem = mapItem
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(mapItem.name ?? "Coordinate Location")
                                        .font(.headline)
                                    Text(mapItem.placemark.title ?? mapItem.getAddress())
                                        .font(.caption)
                                    Text("Tap to fillout details")
                                }
                            })
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                      
                    }
                    .animation(.easeOut(duration: 0.5))
                    .padding(.horizontal, 16)
                }
                .shadow(radius: 5)
                .frame(maxHeight: 300)
                
                Spacer()
                

                
                HStack {
                    
//                    Button {
//                        vm.showActionSheet.toggle()
//                    } label: {
//                        Image("trail")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 45)
//                    }
//                    .fullScreenCover(isPresented: $vm.showTrailForm) {
//                        isHunt = false
//                    } content: {
//                        PostTrailForm(isHunt: $isHunt, mapItem: mapItem)
//                    }


                    Button(action: {
                        vm.searchQuery = ""
                    }, label: {
                        HStack {
                            Image("marker")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            Text("Clear Map")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(5)

                           
                    })
                    .padding()
                    .animation(.easeOut(duration: 0.5))
                    .opacity(vm.mapItems.count >= 1 ? 1 : 0)
                    

                        
                        Button {
                            AnalyticsService.instance.droppedPin()
                            vm.dropPin()
                        } label: {
                            Image("Post Pin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45)
                        }
                    .opacity(vm.mapItems.count >= 1 ? 0 : 1)
                        
                    

                }
                .padding(.horizontal, 15)

                Spacer()
                    .frame(height: 50)
             
                Spacer()
                    .frame(height: vm.keyboardHeight)

            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .actionSheet(isPresented: $vm.showActionSheet) {
            return ActionSheet(title: Text("What type of trail is this?"), message: nil, buttons: [
                
            .default(Text("Normal Trail"), action: {
                vm.showTrailForm.toggle()
            }),
            
            .default(Text("Scavenger Hunt"), action: {
                isHunt = true
                vm.alertMessgae = "Start by choosing a starting location"
                vm.showAlert.toggle()
            }),
            
            .cancel()
        ])
        }
        .alert(isPresented: $vm.showAlert) {
            return Alert(title: Text(vm.alertMessgae))
        }
        

    }
    
}



struct EditMap_Previews: PreviewProvider {
    @State static var mapItem: MKMapItem = MKMapItem()
    static var previews: some View {
        EditMap(mapItem: $mapItem)
            .colorScheme(.dark)
    }
}
