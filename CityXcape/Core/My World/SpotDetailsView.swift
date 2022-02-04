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

    @State var captions: [String] = ["", "", ""]
    @State var spot: SecretSpot
    
    @ObservedObject var vm: SpotViewModel = SpotViewModel()
    let manager = CoreDataManager.instance
    
    @State private var isEditing: Bool = false
    @State private var showStreetPass: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var actionSheetType: SpotActionSheetType = .general
    @State private var currentlyEditing: Bool = false
    @State private var showUsers: Bool = false
    @State private var showComments: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertmessage: String = ""
    
    
 
    init(spot: SecretSpot) {
        _spot = State(initialValue: spot)
    }
    
    var body: some View {
                
                VStack(alignment: .center, spacing: 0) {
                    
                    ZStack {
                        Ticker(profileUrl: spot.ownerImageUrl, captions: $captions)
                            .frame(height: 120)
                            .opacity(isEditing ? 0 : 1)

                        
                        TextField(spot.spotName, text: $vm.newSpotName, onCommit: {
                            if !vm.newSpotName.isEmpty {
                                vm.editSpotName(postId: spot.id)
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
                        
                        TabView {
                
                            ForEach(spot.imageUrls, id: \.self) { url in
                                
                                    WebImage(url: URL(string: url))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                      
                        }
                        .opacity(isEditing ? 0 : 1)
                        .tabViewStyle(PageTabViewStyle())
                        
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
                                        WebImage(url: URL(string: spot.imageUrls.first ?? ""))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: .infinity)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
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
                            
                            
                            TextField(spot.description ?? "Enter a description", text: $vm.newDescription, onCommit: {
                                if !vm.description.isEmpty {
                                    vm.editSpotDescription(postId: spot.id)
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
                    
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            AnalyticsService.instance.touchedRoute()
                            vm.openGoogleMap(spot: spot)
                            }, label: {
                                VStack {
                                    Image("walking")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                    Text(vm.getDistanceMessage(spot: spot))
                                        .font(.subheadline)
                                        .fontWeight(.thin)
                                        .foregroundColor(.white)
                                }
                            })
                            .opacity(isEditing ? 0 : 1)
                        
                        Button {
                            alertmessage = "This spot is for the \(spot.world) community"
                            showAlert.toggle()
                            } label: {
                                VStack {
                                    Image("globe")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20)
                                    
                                    
                                        Text("\(spot.world)")
                                            .font(.subheadline)
                                            .fontWeight(.thin)
                                            .lineLimit(1)
                                            .frame(width: 65)
                                       
                                       
                                }
                            }
                            .opacity(isEditing ? 0 : 1)

                        
                        
                        Button {
                            showUsers.toggle()
                            vm.getSavedbyUsers(postId: spot.id)
                            AnalyticsService.instance.checkSavedUsers()
                        } label: {
                            VStack {
                               Image("dot")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 27)
                                
                                Text(vm.getSavesMessage(spot: spot))
                                    .font(.subheadline)
                                    .fontWeight(.thin)
                                    .offset(y: -3)
                            }

                        }
                        .opacity(isEditing ? 0 : 1)
                        .sheet(isPresented: $showUsers) {
                            SaveDetailsView(spot: spot, vm: vm)
                        }
                        
                        Button {
                                //Comment code.
                            showComments.toggle()
                            vm.getComments(postId: spot.id)
                            AnalyticsService.instance.viewedComments()
                            } label: {
                                VStack {
                                    Image(systemName: "bubble.left.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 21)
                                    
                                    
                                        Text("Comments")
                                        .font(.subheadline)
                                        .fontWeight(.thin)
                                       
                                }
                            }
                            .sheet(isPresented: $showComments) {
                                CommentsView(spot: spot, vm: vm)
                            }
                            .opacity(isEditing ? 0 : 1)

                        
                        Spacer()
                        
                        Button(action: {
                            showActionSheet.toggle()
                        }, label: {
                            
                            VStack {
                                Image(systemName: "ellipsis")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                .rotationEffect(.init(degrees: 90))
                                
                            }
                        })
                    
                        
                       
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                
                   
                    
                    if isEditing {
                        TextField(spot.world, text: $vm.newWorld, onCommit:  {
                            if !vm.newWorld.isEmpty {
                                vm.editWorldTag(postId: spot.id)
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
                    
                    
                        Spacer()
                        
                        Button {
                            vm.checkInSecretSpot(spot: spot, completion: { (exist, success) in
                                if exist {
                                    alertmessage = "You've already checkedin this spot"
                                    showAlert.toggle()
                                }
                                
                                if !success {
                                    alertmessage = "You need to be there to check in"
                                    showAlert.toggle()
                                }
                            })
                        } label: {
                        
                                Text("Check-in")
                                    .font(.title3)
                                    .fontWeight(.thin)
                                    .frame(width: 120, height: 40)
                                    .background(Color.cx_orange)
                                    .opacity(0.6)
                                    .cornerRadius(5)
                            
                        }
                        .disabled(vm.disableCheckin)
                        .opacity(isEditing ? 0 : 1)
                        
                        Spacer()
                        
                   

                    }
                    .padding(.top, 50)
                    .sheet(isPresented: $showStreetPass) {
                        //TBD
                    } content: {
                        let user = User(id: spot.ownerId, displayName: spot.ownerDisplayName, profileImageUrl: spot.ownerImageUrl)
                        PublicStreetPass(user: user)
                    }

                    
                
                
            }
            .foregroundColor(.accent)
            .colorScheme(.dark)
            .onAppear(perform: {
                AnalyticsService.instance.viewedSecretSpot()
                DataService.instance.updatePostViewCount(postId: spot.id)
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
            .alert(isPresented: $showAlert) {
                return Alert(title: Text(alertmessage), message: nil)
            }
            .sheet(isPresented: $vm.showPicker, onDismiss: {
                //TBD
                if vm.addedImage {
                    switch vm.imageSelected {
                    case .one:
                        
                        vm.updateMainSpotImage(postId: spot.id) {  url in
                            
                            if spot.imageUrls.indices.contains(0) {
                                spot.imageUrls.remove(at: 0)
                            }
                            spot.imageUrls.insert(url, at: 0)
                            vm.refresh.toggle()
                            
                        }
                    case .two:
                        vm.updateAdditonalImage(postId: spot.id, image: vm.selectedImageII, number: 2) { url in
                            //I'll be back
                            
                            if spot.imageUrls.indices.contains(1) {
                                spot.imageUrls.remove(at: 1)
                            }
                            spot.imageUrls.insert(url, at: 1)
                            vm.refresh.toggle()
                        }
                    case .three:
                        vm.updateAdditonalImage(postId: spot.id, image: vm.selectedImageIII, number: 3) { url in
                            //I'll be back
                            
                            if spot.imageUrls.indices.contains(2) {
                                spot.imageUrls.remove(at: 2)
                            }
                            spot.imageUrls.insert(url, at: 2)
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
            .background(Color.black.edgesIgnoringSafeArea(.all))
            

        
        
    }
    
    
    func getActionSheet() -> ActionSheet {
        
        let uid = userId ?? ""
        
                
        switch actionSheetType {
            case .general:
                return ActionSheet(title: Text("What would you like to do"), message: nil, buttons: [
                    
                  
                .default(Text(isEditing ? "Done" : "Edit"), action: {
                    if spot.ownerId == uid {
                        
                        if isEditing {
                            manager.fetchSecretSpots()
                        }
                        
                        isEditing.toggle()
                        
                    } else {
                        vm.alertmessage = "You don't have editing permissions"
                        vm.showAlert = true
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
    @State static var refresh: Bool = false

    static var previews: some View {

        
        let spot = SecretSpot(postId: "disnf", spotName: "The Magic Garden", imageUrls: ["https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F3rD6bKzwCbOEpfU51sYF%2F1?alt=media&token=2c45942e-5a44-4dd1-aa83-a678bb848c4b","https://cdn10.phillymag.com/wp-content/uploads/sites/3/2018/07/Emily-Smith-Cory-J-Popp-900x600.jpg", "https://apricotabroaddotco.files.wordpress.com/2019/03/philadelphia-magic-gardens.jpg"], longitude: 1010, latitude: 01202, address: "1229 Spann avenue", description: "This is the best secret spot in the world. Learn all about fractal mathematics", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), price: 1, viewCount: 1, saveCounts: 1, isPublic: true, ownerId: "q4SALDGpjtZLIVtVibHMQa8NpwD3", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073")

        SpotDetailsView(spot: spot)
    }
}
