//
//  PostTrailForm.swift
//  CityXcape
//
//  Created by James Allan on 6/17/22.
//

import SwiftUI
import MapKit

struct PostTrailForm: View {
    
    
    //Add location object for trail start
    @Environment(\.presentationMode) var presentationMode
    @State var isHunt: Bool = false
    @State var mapItem: MKMapItem
    @StateObject var vm: PostTrailViewModel = PostTrailViewModel()
    
    var body: some View {
        
        NavigationView {
          
            
            Form {
                
                Section(header: Text("General Info")) {
                    TextField(vm.namePlaceHolder, text: $vm.trailName)
                        .frame(height: 40)
                    
                    TextField(vm.detailsPlaceHolder, text: $vm.trailDetails)
                        .frame(height: 40)
                    
                    TextField(vm.worldPlaceHolder, text: $vm.world)
                        .frame(height: 40)
                    Toggle(isHunt ? "Scavenger Hunt" : "Trail" , isOn: $isHunt)
                }
                
                
                Section(header: Text("Upload Thumbnail")) {
                    addImageButton
                        .listRowInsets(EdgeInsets())
                }
                
               
                Section(header: Text("Price: \(vm.streetcred) StreetCred, \(vm.selectedSpots.count) spot(s)" )) {
                    Stepper("Number of StreetCred", value: $vm.streetcred, in: 1...100)
                    addSpotButton

                }
                
         
                
                if isHunt {
                    Section(header: Text("Time & Location")) {
                        DatePicker(vm.datedescript, selection: $vm.startDate)
                        DatePicker(vm.datedescript2, selection: $vm.endDate)
                        Text(mapItem.getAddress())
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                    }
                }
                
             

                Section(header: Text("Finish")) {
                   publishButton
                        
                }
                

              //End of Form
            }
            .navigationBarTitle("Create \(isHunt ? "Hunt" : "Trail")", displayMode: .inline)
            .navigationBarItems(trailing: closeButton)
 
          //NavigationView
        }
        .colorScheme(.dark)
        .alert(isPresented: $vm.showAlert, content: {
            return Alert(title: Text(vm.alertMessage))
        })
        .actionSheet(isPresented: $vm.actionSheet) {
            ActionSheet(title: Text("Source Options"), message: nil, buttons: [
                .default(Text("Camera"), action: {
                    vm.sourceType = .camera
                    vm.showPicker.toggle()
                }),
                .default(Text("Photo Library"), action: {
                    vm.sourceType = .photoLibrary
                    vm.showPicker.toggle()
                }),
                
                .cancel()
                
            ])
            
        }
        
        //End of body
    }
}



extension PostTrailForm {
   
    
    private var addImageButton: some View {
        
        Button {
            vm.actionSheet.toggle()
        } label: {
            if let image = vm.selectedImage {
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    .frame(width: UIScreen.screenWidth / 2)
                }
            } else {
                    Image("trail_image")
                        .resizable()
                        .scaledToFill()
            }
        }
        .sheet(isPresented: $vm.showPicker, content: {
            ImagePicker(imageSelected: $vm.selectedImage, videoURL: $vm.videoURL, sourceType: $vm.sourceType)
                .colorScheme(.dark)
        })
        
    }
    

    
    private var addSpotButton: some View {
        Button {
            vm.showList.toggle()
        } label: {
            HStack {
                Image("pin_blue")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 25)
                Text(vm.showListMessage())
                    .font(.title3)
                    .fontWeight(.thin)
            }
            .foregroundColor(.cx_blue)
            

        }
        .fullScreenCover(isPresented: $vm.showList) {
            SpotListView()
                .environmentObject(vm)
        }
    }
                
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark.seal")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: 25)
        })
    }

    
    private var publishButton: some View {
        Button {
            //Post to DB
            vm.postTrailtoDb(location: mapItem, isHunt: isHunt)
        } label: {
            HStack {
                Spacer()
                Image("trail")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text("Create \(isHunt ? "Hunt" : "Trail")")
                    .font(.headline)
                Spacer()
            }
        }
        
    }
    
    
    
    
}

struct PostTrailForm_Previews: PreviewProvider {
    static var previews: some View {
        PostTrailForm(mapItem: MKMapItem())
    }
}
