//
//  PostSpotFormView.swift
//  CityXcape
//
//  Created by James Allan on 8/30/21.
//

import SwiftUI
import MapKit
import CoreLocation
import AVKit

struct PostSpotForm: View {
    
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedTab: Int
    @StateObject var vm: PostViewModel
    var mapItem: MKMapItem
    
    
    var body: some View {
        
            NavigationView {
                Form {
                    TextField("Secret Spot Name", text: $vm.spotName)
                        .frame(height: 40)
                        .fullScreenCover(isPresented: $vm.showSignUp) {
                            OnboardingView()
                        }
                    
                    
                    TextField(vm.detailsPlaceHolder, text: $vm.details)
                        .frame(height: 40)
                    
                    Section("\(Image(systemName: "eye.fill")) Visibility") {
                        Toggle(vm.isPublic ? "Public" : "Private", isOn: $vm.isPublic)
                        
                        
                            TextField(vm.worldPlaceHolder, text: $vm.world, onCommit:  {
                                vm.converToHashTag()
                            })
                            .opacity(!vm.isPublic ? 0 : 1)
                           
                           
//                         else {
//                            Text(vm.privatePlaceHolder)
//                                .foregroundColor(.white)
//
//                        }
                              
                    }
    
                    Section("Upload Image") {
                        Button(action: {
                            vm.selectedImage = nil
                            vm.showActionSheet.toggle()
                        }, label: {
                            ZStack {
                         
                                if let image = vm.selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(12)
                                } else if let videoUrl = vm.videoUrl {
                                    if let avPlayer = vm.avPlayer {
                                        VideoPlayer(player: avPlayer)
                                            .frame(height: 400)
                                        }
                                } else {
                                    Image("spot_image")
                                        .resizable()
                                        .scaledToFit()
                                        

                                    
                                        
                                }
                                                                        
                                ProgressView()
                                    .opacity(vm.isLoading ? 1 : 0)
                                    .scaleEffect(3)
                            }
                            
                        })
                        .listRowInsets(EdgeInsets())

                    }
                    
                    Section(header: Text("Price: \(vm.price) StreetCred" )) {
                        Stepper("Number of StreetCred", value: $vm.price, in: 1...100)

                    }
                            
                    locationView
                        .popover(isPresented: $vm.presentPopover, content: {
                            Text(vm.worldDefinition)
                        })
                         
                    Section(header: Text("Finish")) {
                            finishButton
                    }
                    

                }
                .navigationBarTitle("Post Spot", displayMode: .inline)
                .navigationBarItems(trailing: closeButton)
                .sheet(isPresented: $vm.showPicker, onDismiss: {
                    if vm.selectedImage == nil {
                        vm.didUploadImage = true
                    }
                    if vm.videoUrl != nil {
                        vm.didUploadVideo = true 
                    }
                }, content: {
                    ImagePicker(imageSelected: $vm.selectedImage, videoURL: $vm.videoUrl, sourceType: $vm.sourceType)
                        .colorScheme(.dark)
                })
               
              
              
                        
            }
            .colorScheme(.dark)
            .actionSheet(isPresented: $vm.showActionSheet) {
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
            .alert(isPresented: $vm.showAlert) {
                return Alert(title: Text(vm.alertMessage), dismissButton: .default(Text("Ok"), action: {
                    dismiss()
                }))
            }
            .fullScreenCover(isPresented: $vm.showCongrats) {
                dismiss()
            } content: {
                CongratsView(vm: vm)
            }
            


    //End of Body
    }
    
    
    
    
}

extension PostSpotForm {
    
    private var locationView: some View {
        HStack {
            Spacer()
             Image(systemName: "location.fill")
                 .resizable()
                 .scaledToFit()
                 .frame(height: 20)
             
             Text(mapItem.getAddress())
                 .multilineTextAlignment(.center)
                 .lineLimit(1)
            Spacer()
         }
         .foregroundColor(.white)
    }
    
    private var finishButton: some View {
        Button(action: {
            vm.isReady(mapItem: mapItem)
        }, label: {
                
            HStack {
                Spacer()
                Image(Icon.pin.rawValue)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                Text("Create Spot")
                    .font(.headline)
                Spacer()
            }
            .foregroundColor(.cx_blue)


        })
        .animation(.easeOut(duration: 0.5))
        .disabled(vm.buttonDisabled)
    }
    
    
    private var closeButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark.seal")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: 25)
        })
    }
    
}

struct CreateSpotFormView_Previews: PreviewProvider {
     @State static var address: String = "1229 Spann Ave, Indianapolis, IN, 46203"
     @State static var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 39.75879282513146, longitude: -86.1373309437772)
    @State static var tabIndex: Int = 1
    static var previews: some View {
        PostSpotForm(selectedTab: $tabIndex, vm: PostViewModel(), mapItem: MKMapItem())
    }
    
}
