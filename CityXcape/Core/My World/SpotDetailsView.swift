//
//  SpotDetailsView.swift
//  CityXcape
//
//  Created by James Allan on 8/20/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SpotDetailsView: View {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @Environment(\.presentationMode) var presentationMode
    @Binding var currentIndex: Int

    @State var captions: [String] = ["", "", ""]
    @State var spot: SecretSpot
    
    @ObservedObject var vm: SpotViewModel = SpotViewModel()
    
    @State private var isEditing: Bool = false
    @State private var showStreetPass: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var showWorldDef: Bool = false
    @State private var actionSheetType: SpotActionSheetType = .general
    
 
    init(spot: SecretSpot, index: Binding<Int>) {
        _spot = State(initialValue: spot)
        self._currentIndex = index
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center) {
                    
                    ZStack {
                        Ticker(profileUrl: spot.ownerImageUrl, captions: $captions)
                            .frame(height: 120)
                            .opacity(isEditing ? 0 : 1)

                        
                        TextField(spot.spotName, text: $vm.newSpotName, onCommit: {
                            if !vm.newSpotName.isEmpty {
                                vm.editSpotName(postId: spot.postId)
                                spot.spotName = vm.newSpotName
                                captions[0] = vm.newSpotName
                                vm.refresh.toggle()
                            }
                        })
                            .padding(.leading, 20)
                            .frame(height: 50)
                            .opacity(isEditing ? 1 : 0)
                    }
                    
                    ZStack {
                        
            
                        WebImage(url: URL(string: spot.imageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.top, 20)
                        
                   
                        
                        
                        TabView {
                            
                          
                                Button {
                                    vm.setupImageSubscriber()
                                    vm.showPicker = true
                                    vm.addedImage = false
                                } label: {
                                    if vm.addedImage {
                                        Image(uiImage: vm.selectedImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } else {
                                        VStack {
                                            LocationCamera(height: 150, color: .white)
                                            Text("Replace Main Image")
                                        }
                                    }
                                }
                            
                        
                            
                            Button {
                                vm.setupImageSubscriber()
                                vm.imageSelected = .two
                                vm.showPicker = true
                                vm.addedImage = false
                            } label: {
                                if vm.addedImage {
                                    Image(uiImage: vm.selectedImageII)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    VStack {
                                        LocationCamera(height: 150, color: .white)
                                        Text("Replace Main Image")
                                    }
                                }
                            }
                            
                            Button {
                                vm.setupImageSubscriber()
                                vm.imageSelected = .three
                                vm.showPicker = true
                                vm.addedImage = false
                            } label: {
                                if vm.addedImage {
                                    Image(uiImage: vm.selectedImageIII)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    VStack {
                                        LocationCamera(height: 150, color: .white)
                                        Text("Replace Main Image")
                                    }
                                }
                            }
                        }
                        .opacity(isEditing ? 1 : 0)
                        .tabViewStyle(PageTabViewStyle())

                        
                        
                
                        
                    }
                    
                    HStack {
                        ZStack {
                            Text(spot.description ?? "")
                                .multilineTextAlignment(.leading)
                                .font(.body)
                                .lineLimit(.none)
                                .padding()
                            .opacity(isEditing ? 0 : 1)
                            
                            
                            TextField(spot.description ?? "", text: $vm.newDescription, onCommit: {
                                if !vm.description.isEmpty {
                                    vm.editSpotDescription(postId: spot.postId)
                                    spot.description = vm.newDescription
                                    vm.refresh.toggle()
                                }
                            })
                                .multilineTextAlignment(.leading)
                                .font(.body)
                                .lineLimit(.none)
                                .padding()
                                .opacity(isEditing ? 1 : 0)
                        }
                        
                        
                        Spacer()
                    }
                    
                    
                    HStack {
                        Button(action: {
                                vm.openGoogleMap(spot: spot)
                            }, label: {
                                HStack {
                                    Image("pin_blue")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                    Text(spot.address)
                                        .foregroundColor(.white)
                                }
                            })
                            .padding()
                        
                        Spacer()
                    }
                        
                    HStack {
                        
                            Button {
                                    vm.showWorldDefinition(spot: spot)
                                } label: {
                                    HStack {
                                        Image("globe")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                        
                                        
                                            Text("\(spot.world)")
                                           
                                    }
                                }
                            
                           
                        Spacer()
                        
                        Button {
                            vm.checkInSecretSpot(spot: spot)
                        } label: {
                            VStack {
                                Image(Icon.check.rawValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 25)
                                
                                Text("Verify")
                                    .font(.caption)
                            }
                        }
                        .disabled(vm.disableCheckin)
                      

                    }
                    .opacity(isEditing ? 0 : 1)
                    .padding(.horizontal, 20)
                    
                    if isEditing {
                        TextField(spot.world, text: $vm.newWorld, onCommit:  {
                            if !vm.newWorld.isEmpty {
                                vm.editWorldTag(postId: spot.postId)
                                spot.world = vm.newWorld
                                vm.refresh.toggle()
                            }
                        })
                            .font(.body)
                            .lineLimit(.none)
                            .padding(.leading, 20)
                            .opacity(isEditing ? 1 : 0)
                    }
                    
                    HStack {
                        Button(action: {
                            showActionSheet.toggle()
                        }, label: {
                            Image(systemName: "ellipsis")
                                .font(.title)
                                .foregroundColor(.white)
                        })
                    
                        
                        Spacer()
                        
                        
                        Button {
                            showStreetPass.toggle()
                            AnalyticsService.instance.touchedProfile()
                        } label: {
                            VStack {
                                UserDotView(imageUrl: spot.ownerImageUrl, width: 30, height: 30)
                                Text("Scout")
                                    .font(.caption)
                            }
                            .padding(.trailing, 20)

                        }

                    }
                    .padding(.leading, 20)
                    .sheet(isPresented: $showStreetPass) {
                        //TBD
                    } content: {
                        PublicStreetPass(uid: spot.ownerId, profileUrl: spot.ownerImageUrl, username: spot.ownerDisplayName, userbio: nil, streetCred: nil)
                    }

                    
                }
                .foregroundColor(.accent)
                
            }
            .colorScheme(.dark)
            .onAppear(perform: {
                AnalyticsService.instance.viewedSecretSpot()
                DataService.instance.updatePostViewCount(postId: spot.postId)
                captions.removeAll()
                let name = spot.spotName
                let distanceString = String(format: "%.0f", spot.distanceFromUser)
                let distance = spot.distanceFromUser > 1 ? "\(distanceString) miles away" : "\(distanceString) mile away"
                let postedby = "Posted by \(spot.ownerDisplayName)"
                captions.append(contentsOf: [name, distance, postedby])
            })
            .actionSheet(isPresented: $showActionSheet, content: {
                getActionSheet()
            })
            .alert(isPresented: $vm.showAlert) {
                return Alert(title: Text(vm.alertmessage), message: nil)
            }
            .sheet(isPresented: $vm.showPicker, onDismiss: {
                //TBD
                if vm.addedImage {
                    switch vm.imageSelected {
                    case .one:
                        vm.updateMainSpotImage(postId: spot.postId) {  url in
                            
                                spot.imageUrl = url
                                vm.refresh.toggle()
                            
                        }
                    case .two:
                        vm.updateAdditonalImage(postId: spot.postId, image: vm.selectedImageII, number: 2) { url in
                            //I'll be back
                            spot.spotImageUrls.append(url)
                            vm.refresh.toggle()
                        }
                    case .three:
                        vm.updateAdditonalImage(postId: spot.postId, image: vm.selectedImageIII, number: 3) { url in
                            //I'll be back
                            spot.spotImageUrls.append(url)
                            vm.refresh.toggle()
                        }
                    }
                }
                
            }, content: {
                
                switch vm.imageSelected {
                case .one:
                    ImagePicker(imageSelected: $vm.selectedImage, sourceType: $vm.sourceType)
                case .two:
                    ImagePicker(imageSelected: $vm.selectedImageII, sourceType: $vm.sourceType)
                case .three:
                    ImagePicker(imageSelected: $vm.selectedImageIII, sourceType: $vm.sourceType)

                }
                
            })
            .fullScreenCover(isPresented: $vm.showCheckin) {
                //Dismiss functions
            } content: {
                VerificationView(spot: spot)
            }
            
          

            

        }
        
    }
    
    
    func getActionSheet() -> ActionSheet {
        
        let uid = userId ?? ""
        
                
        switch actionSheetType {
            case .general:
                return ActionSheet(title: Text("What would you like to do"), message: nil, buttons: [
                    
                  
                .default(Text(isEditing ? "Done" : "Edit"), action: {
                    if spot.ownerId == uid {
                        isEditing.toggle()
                    } else {
//                        vm.alertmessage = "You don't have editing permissions"
//                        vm.showAlert = true
                        isEditing.toggle()
                    }
                    }),
            
                .default(Text("Report"), action: {
                    self.actionSheetType = .report
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showActionSheet.toggle()
                    }
                }),
                
                .default(Text("Delete"), action: {
                    self.actionSheetType = .delete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showActionSheet.toggle()
                    }
                }),
                
                .cancel()
            ])
        case .report:
            return ActionSheet(title: Text("Why are you reporting this post"), message: nil, buttons: [
                .destructive(Text("This is innapropriate"), action: {
                    vm.reportPost(reason: "This is innapropriate", spot: spot)
                }),
                .destructive(Text("This is spam"), action: {
                    vm.reportPost(reason: "This is spam", spot: spot)
                }),
                .destructive(Text("It made me uncomfortable"), action: {
                    vm.reportPost(reason: "It made me uncomfortable", spot: spot)
                }),
                .cancel( {
                    self.actionSheetType = .general
                })
            ])
        case .delete:
            return ActionSheet(title: Text("Are You sure you want to delete this post?"), message: nil, buttons: [
                .destructive(Text("Yes"), action: {
                    currentIndex = 0
                    vm.deletePost(spot: spot) { success in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }),
                
                .cancel(Text("No"), action: {
                    if isEditing {
                        isEditing.toggle()
                    }
                })
            ])
        }
    }
  
    
}


struct SpotDetailsView_Previews: PreviewProvider {
    @State static var integer: Int = 1

    static var previews: some View {

        
        let spot = SecretSpot(postId: "disnf", spotName: "The Big Duck", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F3rD6bKzwCbOEpfU51sYF%2F1?alt=media&token=2c45942e-5a44-4dd1-aa83-a678bb848c4b", longitude: 1010, latitude: 01202, address: "1229 Spann avenue", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), viewCount: 1, price: 1, saveCounts: 1, isPublic: true, description: "This is the best secret spot in the world. Learn all about fractal mathematics", ownerId: "q4SALDGpjtZLIVtVibHMQa8NpwD3", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", spotImageUrls: [""])

        SpotDetailsView(spot: spot, index: $integer)
    }
}
