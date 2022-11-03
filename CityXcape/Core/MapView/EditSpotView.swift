//
//  EditSpotView.swift
//  CityXcape
//
//  Created by James Allan on 4/18/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditSpotView: View {
    @State var spot: SecretSpot
    @StateObject var vm: EditViewModel = EditViewModel()
    let height: CGFloat = UIScreen.screenSize.height / 3
    
    
    var body: some View {
        
        ScrollView {

                editImages
                editTitle
                editDescription
                editWorld
                editPrice
                changeLocation

            //End of Scroll View
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .alert(isPresented: $vm.showAlert, content: {
            return Alert(title: Text(vm.alertMessage))
        })
        .sheet(isPresented: $vm.showPicker) {
            updateImage()
        } content: {
            ImagePicker(imageSelected: $vm.image, videoURL: $vm.videoUrl, sourceType: $vm.sourceType)
        }


    }
    

    
    
    

}

struct EditSpotView_Previews: PreviewProvider {
    static var previews: some View {
        EditSpotView(spot: SecretSpot.spot)
            .preferredColorScheme(.dark)
    }
}



extension EditSpotView {
    
    private var editImages: some View {
        TabView {

            ForEach(spot.imageUrls, id: \.self) { url in
                
                
                    WebImage(url: URL(string: url))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: .infinity)
                        .overlay(
                            ZStack {
                                LinearGradient(colors: [Color.clear, Color.black], startPoint: .center, endPoint: .bottom)
                        
                            })
                        .onTapGesture {
                            vm.findIndexof(url: url, spot: spot)
                            vm.showPicker.toggle()
                    }
                }
            
            
            ZStack {
                LocationCamera(height: 150, color: .white)
                    .onTapGesture {
                        vm.index = spot.imageUrls.count + 1
                        vm.showPicker.toggle()
                }
                
                ProgressView()
                    .scaleEffect(3)
                    .opacity(vm.isLoading ? 1 : 0)
            }
      
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: height)
    }
    
    private var changeLocation: some View {
        
        Button {
            vm.showMap.toggle()
        } label: {
            HStack {
                
                Image("pin_blue")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                
                Text(vm.getAddress())
                    .fontWeight(.thin)
                    .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $vm.showMap, onDismiss: {
            vm.showCoordinates = true
            vm.updateLocation(spotId: spot.id)
        }, content: {
            EditMap(mapItem: $vm.selectedMapItem)
                .colorScheme(.dark)
        })
        
    }
    
    private var editTitle: some View {
        HStack {
            TextField(spot.spotName, text: $vm.title, onCommit: {
                if !vm.title.isEmpty {
                    vm.editSpotName(postId: spot.id)
                    spot.spotName = vm.title
                }
            })
            .frame(height: 50)
            
            Spacer()
            Image("pin_blue")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
        }
        .padding(.horizontal, 20)
        .foregroundColor(.white)

    }
    
    private var editDescription: some View {
        VStack(alignment: .trailing) {
            
            ZStack {
                Text(spot.description ?? "No description provided")
                .lineLimit(nil)
                .foregroundColor(.gray)
                .opacity(vm.editDescription ? 0 : 1)
                
                TextField("Enter a description", text: $vm.description, onCommit: {
                    if !vm.description.isEmpty {
                        vm.editSpotDescription(postId: spot.id)
                        spot.description = vm.description
                    }
                })
                .opacity(vm.editDescription ? 1 : 0)
                
            }
            
            Button {
                withAnimation {
                    vm.editDescription.toggle()
                }
            } label: {
                Image(systemName:"square.and.pencil")
                    .foregroundColor(.gray)
                    .font(.title3)
            }

        }
        .padding(.horizontal, 20)
        .foregroundColor(.white)
    }
    
    private var editWorld: some View {
        HStack {
            Image("globe")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(height: 30)
            TextField(spot.world, text: $vm.world, onCommit: {
                if !vm.world.isEmpty {
                    vm.editWorldTag(postId: spot.id)
                    spot.world = vm.world
                }
            })
                .foregroundColor(.white)
            
            Spacer()
            
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    
    private var editPrice: some View {
        HStack {
            Image(systemName: "dollarsign.circle")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.gray)
                .scaledToFit()
                .frame(height: 30)
            
            TextField("This spot cost \(spot.price) STC", text: $vm.streetcred, onCommit: {
                vm.editPrice(postId: spot.id)
            })
                .keyboardType(.numberPad)
        }
        .padding(.horizontal, 20)

    }
    
    fileprivate func updateImage() {
        
        if vm.index == 0 {
            vm.updateMainSpotImage(postId: spot.id) { url in
                spot.imageUrls[0] = url ?? ""
            }
        }
        
        if vm.index > spot.imageUrls.count {
            vm.addImage(postId: spot.id) { url in
                spot.imageUrls.append(url ?? "")
            }
        }
        
        if spot.imageUrls.indices.contains(vm.index) {
            let oldUrl = spot.imageUrls[vm.index]
            vm.updateExtraImage(postId: spot.id, oldUrl: oldUrl) { url in
                spot.imageUrls[vm.index] = url ?? ""
            }
        }
        
    }
}
