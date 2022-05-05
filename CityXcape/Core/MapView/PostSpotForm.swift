//
//  PostSpotFormView.swift
//  CityXcape
//
//  Created by James Allan on 8/30/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct PostSpotForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    @Binding var selectedTab: Int
    @StateObject var vm = PostViewModel()
    var mapItem: MKMapItem
    
    
    var body: some View {
        
            ScrollView {
                VStack {
                    Text("Post Spot")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    
                    TextField("Secret Spot Name", text: $vm.spotName)
                        .placeholder(when: vm.spotName.isEmpty) {
                            Text("Secret Spot Name").foregroundColor(.gray)
                    }
                        .padding()
                        .background(Color.white)
                        .accentColor(.black)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                        .padding(.horizontal, 12)
                    
                     Spacer()
                        .frame(maxHeight: 30)
                    
                    VStack(spacing: 10) {
                        HStack {
                            
                            Image(Icon.history.rawValue)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                            Text("Description")
                                .fontWeight(.light)
                                .lineLimit(6)
        
                        }
                        .foregroundColor(.white)
                        
                        TextField(vm.detailsPlaceHolder, text: $vm.details)
                            .placeholder(when: vm.details.isEmpty) {
                                Text(vm.detailsPlaceHolder).foregroundColor(.gray)
                        }
                            .frame(maxWidth: .infinity)
                            .frame(height: 70)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .cornerRadius(4)
                            .keyboardType(.alphabet)
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            vm.isPublic.toggle()
                        }, label: {
                            if vm.isPublic {
                                Image("globe")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                            } else {
                                Image(systemName: "lock.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.yellow)
                            }
                         
                        })
                        
                        if vm.isPublic {
                            TextField(vm.worldPlaceHolder, text: $vm.world, onCommit:  {
                                vm.converToHashTag()
                            })
                            .placeholder(when: vm.world.isEmpty) {
                                Text(vm.worldPlaceHolder).foregroundColor(.gray)
                        }
                            .padding()
                            .background(Color.white)
                            .accentColor(.black)
                            .foregroundColor(.black)
                            .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
                        } else {
                            Text(vm.privatePlaceHolder)
                                .foregroundColor(.white)
                               
                        }
                        
                    }
                    .padding(.bottom, 10)
                    
              
                            
                        Button(action: {
                            vm.showActionSheet.toggle()
                        }, label: {
                            ZStack {
                                if let image = vm.selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(12)
                                } else {
                                    LocationCamera(height: 150, color: .white)
                                }
                                
                                ProgressView()
                                    .opacity(vm.isLoading ? 1 : 0)
                                    .scaleEffect(3)
                            }
                            
                    })
                    
                            
                        
                    HStack {
                        Text("Price:")
                            .foregroundColor(.white)
                        TextField(" 1", text: $vm.priceString)
                            .padding(.vertical, 5)
                            .background(Color.white)
                            .accentColor(.black)
                            .keyboardType(.alphabet)
                            .foregroundColor(.black)
                            .frame(width: 50)
                            .placeholder(when: vm.priceString.isEmpty) {
                                Text(vm.pricePlaceHolder).foregroundColor(.gray)
                        }
                        
                        Button {
                            vm.alertMessage = "Set the streetcred amount required for others to save this spot"
                            vm.showAlert = true
                        } label: {
                            VStack(spacing: 0) {
                                Text("STC")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                
                                Image(systemName:"info.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 10)
                            }
                        }

                   
                    }
                    
                    HStack {
                        Image(Icon.pin.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        
                        Text(mapItem.getAddress())
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                    .foregroundColor(.white)
                    .padding()
                
                        
                            Button(action: {
                                vm.isReady(mapItem: mapItem)
                            }, label: {
                                HStack {
                                    Image(Icon.pin.rawValue)
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    Text("Create Spot")
                                        .font(.headline)
                                }
                                    .padding()
                                    .foregroundColor(.blue)
                                    .background(Color.white)
                                    .cornerRadius(4)
                                    .padding()

                            })
                            .animation(.easeOut(duration: 0.5))
                            .disabled(vm.buttonDisabled)

                    
            
                }
                .sheet(isPresented: $vm.showPicker, content: {
                    ImagePicker(imageSelected: $vm.selectedImage, sourceType: $vm.sourceType)
                        .colorScheme(.dark)
                })
                .fullScreenCover(isPresented: $vm.presentCompletion, onDismiss: {
                    
                    selectedTab = 0
                    NotificationCenter.default.post(name: spotCompleteNotification, object: nil)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, content: {
                    CongratsView()
                    
                })
                .alert(isPresented: $vm.showAlert, content: {
                    Alert(title: Text(vm.alertMessage))
                })
                .popover(isPresented: $vm.presentPopover, content: {
                    Text(vm.worldDefinition)
                })
                .actionSheet(isPresented: $vm.showActionSheet) {
                    ActionSheet(title: Text("Source Options"), message: nil, buttons: [
                        .default(Text("Camera"), action: {
                            vm.sourceType = .camera
                            vm.showPicker.toggle()
                        }),
                        .default(Text("Photo Library"), action: {
                            vm.sourceType = .photoLibrary
                            vm.showPicker.toggle()
                        })
                    ])
                    
                }
                        
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))


    
    }
    
    
    
    
}

struct CreateSpotFormView_Previews: PreviewProvider {
     @State static var address: String = "1229 Spann Ave, Indianapolis, IN, 46203"
     @State static var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 39.75879282513146, longitude: -86.1373309437772)
    @State static var tabIndex: Int = 1
    static var previews: some View {
        PostSpotForm(selectedTab: $tabIndex, mapItem: MKMapItem())
    }
    
}
