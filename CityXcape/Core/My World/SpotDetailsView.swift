//
//  SpotDetailsView.swift
//  CityXcape
//
//  Created by James Allan on 8/20/21.
//

import SwiftUI
import SDWebImageSwiftUI
import CodeScanner

struct SpotDetailsView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var spot: SecretSpot
    @StateObject var vm: SpotViewModel = SpotViewModel()
    @StateObject var mapViewModel: MapViewModel = MapViewModel()
    let height = UIScreen.screenHeight
    
    @State var detailsTapped: Bool = false
    @State private var showUsers: Bool = false
    @State private var showMission: Bool = false

    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var image: UIImage?
    
    init(spot: SecretSpot) {
        _spot = State(initialValue: spot)
    }
    
    var body: some View {
                
                VStack {
                    
                    ZStack {
                        
                        ImageSlider(images: spot.imageUrls)

                        
                        DetailsView(spot: spot, showActionSheet: $vm.showActionSheet, type: .SpotDetails)
                            .opacity(detailsTapped ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: detailsTapped)
                        
                        if vm.showStamp {
                            StampView(spot: spot)
                                .onAppear {
                                    vm.calculateRank()
                                    vm.getScoutLeaders()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        vm.showShareView.toggle()
                                    }
                                }
                                .sheet(isPresented: $vm.showShareView) {
                                    self.presentationMode.wrappedValue.dismiss()
                                
                                } content: {
                                    ShareView(vm: vm, spot: spot)
                                }

                        }
                        //End of Image ZStack
                    }
                    
                        HStack {
                            Image("pin_blue")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                            Text(spot.spotName)
                                .font(.title)
                                .fontWeight(.thin)
                                .lineLimit(1)
                            Spacer()
                         
                            Text(vm.getDistanceMessage(spot: spot))
                          
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)
                        .frame(width: UIScreen.screenWidth)
                        .fullScreenCover(isPresented: $vm.showCheckin) {
                            CheckinView(spot: spot, vm: vm)
                        }
                    
                 
                    
                    HStack(spacing: 10) {
                        
                        Button {
                            //TBD
                            vm.analytics.viewedDetails()
                            detailsTapped.toggle()
                        } label: {
                            Image("info")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .padding(.leading, 4)
                                .animation(.easeOut, value: detailsTapped)
                                
                        }
                            
     
                        Button {
                            showUsers.toggle()
                            vm.getSavedbyUsers(postId: spot.id)
                            vm.analytics.checkSavedUsers()
                        } label: {
                            VStack {
                               Image("save")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50)
                                
                            }

                        }
                        .sheet(isPresented: $showUsers) {
                            SavesView(spot: spot, vm: vm)
                        }

                        
                        Button {
                            vm.getComments(postId: spot.id)
                            vm.showComments.toggle()
                            vm.analytics.viewedComments()
                        } label: {
                            Image("comment")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 55)
                        }
                        .sheet(isPresented: $vm.showComments) {
                            CommentsView(spot: spot, vm: vm)
                        }
                        
                        
                        Button {
                            vm.isOwner ? vm.showBarCode.toggle()
                            : vm.presentScanner.toggle()
                        } label: {
                            Image("Barcode")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        }
                        .sheet(isPresented: $vm.showBarCode) {
                            Image(uiImage: vm.generateBarCode(spot: spot))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }

                     
                    
                       
                    }
                    .padding(.top, 10)
                    
                    
                    HStack {
                      
                        Button {
                            //Load Route Screen
                            vm.analytics.viewedMission()
                            showMission.toggle()
                            
                        } label: {
                            Text("Get Stamp")
                                .foregroundColor(.white)
                                .fontWeight(.light)
                                .font(.subheadline)
                                .frame(width: 160, height: 45)
                                .overlay(
                                   Rectangle()
                                       .stroke(Color.white, lineWidth: 1)
                                       )
                                .animation(.easeOut, value: showMission)
                                
                        }
                        .fullScreenCover(isPresented: $showMission, onDismiss: {
                            //TBD
                        }, content: {
                            MissionView(spot: spot, vm: mapViewModel, spotModel: vm)
                        })
                        
                  

                    }
                    .padding(.top, 50)
               

                    
                
                
            }
            .foregroundColor(.accent)
            .colorScheme(.dark)
            .onAppear(perform: {
                vm.checkedOwner(spot: spot)
                vm.analytics.viewedSecretSpot()
                DataService.instance.updatePostViewCount(postId: spot.id)
                vm.updateSecretSpot(postId: spot.id)
                vm.checkIfPresent(spot: spot)
            })
            .fullScreenCover(isPresented: $vm.showPicker, content: {
                ImagePicker(imageSelected: $image, sourceType: $sourceType)
            })
            .actionSheet(isPresented: $vm.showActionSheet, content: {
                getActionSheet()
            })
            .alert(isPresented: $vm.showAlert) {
                return Alert(title: Text(vm.alertMessage))
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $vm.presentScanner) {
                CodeScannerView(codeTypes: [.qr], scanMode: .once) { result in
                    switch result {
                    case .success(let result):
                        vm.presentScanner = false
                        vm.checkInWithQrCode(spot: spot, qrString: result.string)
                    case .failure(let error):
                        print("There was an error \(error.localizedDescription)")
                        vm.alertMessage = error.localizedDescription
                        vm.showAlert.toggle()
                    }
                }
            }

        
        
    }
    
    
    func getActionSheet() -> ActionSheet {
                
        switch vm.actionSheetType {
            case .general:
                return ActionSheet(title: Text("What would you like to do"), message: nil, buttons: [
                    
                .default(Text("Report"), action: {
                    vm.actionSheetType = .report
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        vm.showActionSheet.toggle()
                    }
                }),
                
                .default(Text("Delete"), action: {
                    vm.actionSheetType = .delete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        vm.showActionSheet.toggle()
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
                    vm.actionSheetType = .general
                })
            ])
        case .delete:
            return ActionSheet(title: Text("Are You sure you want to delete this post?"), message: nil, buttons: [
                .destructive(Text("Yes"), action: {
                    vm.deletePost(spot: spot) { success in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                            vm.manager.fetchSecretSpots()
                        }
                    }
                }),
                
                .cancel(Text("No"), action: {
                    
                })
            ])
        }
    }
    
  
    
}


struct SpotDetailsView_Previews: PreviewProvider {
    @State static var integer: Int = 1
    @State static var refresh: Bool = false

    static var previews: some View {

        SpotDetailsView(spot: SecretSpot.spot)
    }
}
