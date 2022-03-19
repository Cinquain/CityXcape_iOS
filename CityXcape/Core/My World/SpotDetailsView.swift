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
    @StateObject var mapViewModel: MapViewModel = MapViewModel()
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
    @State private var showMission: Bool = false
  
    
 
    init(spot: SecretSpot) {
        _spot = State(initialValue: spot)
        vm.didLike = spot.likedByUser
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
                        
                        if vm.showStamp {
                            StampView(spot: spot)
                        }
                        
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
                        
                       
                                    
                        Text(vm.getViews(spot: spot))
                            .font(.subheadline)
                            .fontWeight(.thin)
                            .foregroundColor(.white)
                            .lineLimit(1)
                                    
                            
                        
                        Spacer()
                        
                        Button {
                            alertmessage = "This spot belongs to the \(spot.world) community"
                            showAlert.toggle()
                            } label: {
                                
                                    Text("\(spot.world)")
                                        .font(.subheadline)
                                        .fontWeight(.thin)
                                        .lineLimit(1)
                                        .frame(width: 60)
                            
                            }
                        
                    }
                    .opacity(isEditing ? 0 : 1)
                    .padding(.horizontal, 20)
                    
          
                    
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
                    
                    
                    HStack(spacing: 10) {
                        
                        Button {
                            showUsers.toggle()
                            vm.getSavedbyUsers(postId: spot.id)
                            AnalyticsService.instance.checkSavedUsers()
                        } label: {
                            VStack {
                               Image("saves")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40)
                                
                            }

                        }
                        .opacity(isEditing ? 0 : 1)
                        .sheet(isPresented: $showUsers) {
                            SavesView(spot: spot, vm: vm)
                        }

                        
                        Button {
                            vm.didLike.toggle()
                            vm.pressLike(postId: spot.id)
                        } label: {
                            VStack(spacing: 0) {
                                LikeAnimationView(color: .red, didLike: $vm.didLike, size: 40)
                                    .padding(.top, -3)
                                
                            }
                        }
                        .opacity(isEditing ? 0 : 1)

              
                        
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
                                        .frame(width: 38)
                                        .foregroundColor(.cx_blue.opacity(0.5))
                                }
                            }
                            .sheet(isPresented: $showComments) {
                                CommentsView(spot: spot, vm: vm)
                            }
                            .opacity(isEditing ? 0 : 1)
                        
                        if spot.verified {
                            Button {
                                //TBD
                                vm.showVerifiers.toggle()
                                vm.getVerifiedUsers(postId: spot.id)
                                AnalyticsService.instance.checkedVerifiers()
                            } label: {
                                Image("checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40)
                                    .padding(.leading, 4)
                                    
                                
                            }
                            .animation(.easeOut)
                            .opacity(isEditing ? 0 : 1)
                            .sheet(isPresented: $vm.showVerifiers) {
                                VerificationView(spot: spot, vm: vm)
                            }
                        }
                       

                        
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
                            //Load Route Screen
                            showMission.toggle()
                            
                        } label: {
                            GetStampedButton(height: 50, width: 200)
                        }
                        .opacity(isEditing ? 0 : 1)
                        .fullScreenCover(isPresented: $showMission, onDismiss: {
                            //TBD
                        }, content: {
                            MissionView(spot: spot, vm: mapViewModel, spotModel: vm)
                        })
                        
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
                vm.updateSecretSpot(postId: spot.id)
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

        
        let spot = SecretSpot(postId: "disnf", spotName: "The Magic Garden", imageUrls: ["https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F3rD6bKzwCbOEpfU51sYF%2F1?alt=media&token=2c45942e-5a44-4dd1-aa83-a678bb848c4b","https://cdn10.phillymag.com/wp-content/uploads/sites/3/2018/07/Emily-Smith-Cory-J-Popp-900x600.jpg", "https://apricotabroaddotco.files.wordpress.com/2019/03/philadelphia-magic-gardens.jpg"], longitude: 1010, latitude: 01202, address: "1229 Spann avenue", description: "This is the best secret spot in the world. Learn all about fractal mathematics", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), price: 1, viewCount: 1, saveCounts: 1, isPublic: true, ownerId: "q4SALDGpjtZLIVtVibHMQa8NpwD3", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", likeCount: 10, didLike: true, verifierCount: 0)

        SpotDetailsView(spot: spot)
    }
}
