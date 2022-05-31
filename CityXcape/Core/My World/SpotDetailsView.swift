//
//  SpotDetailsView.swift
//  CityXcape
//
//  Created by James Allan on 8/20/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SpotDetailsView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var spot: SecretSpot
    @StateObject var vm: SpotViewModel = SpotViewModel()
    @StateObject var mapViewModel: MapViewModel = MapViewModel()
    
    let height = UIScreen.screenHeight
    
    @State var detailsTapped: Bool = false
    @State private var showUsers: Bool = false
    @State private var showMission: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
  
    
    init(spot: SecretSpot) {
        _spot = State(initialValue: spot)
        vm.didLike = spot.likedByUser
    }
    
    var body: some View {
                
                VStack {

                    
                    ZStack {
                        
                        ImageSlider(images: spot.imageUrls)

                        
                        DetailsView(spot: spot, vm: vm)
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
                            vm.presentShareSheet(spot: spot)
                        } label: {
                            VStack(spacing: 0) {
                                Image("share")
                                     .resizable()
                                     .aspectRatio(contentMode: .fit)
                                     .frame(width: 50)
                            }
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

                     
                    
                       
                    }
                    .padding(.top, 10)
                    
                    
                    HStack {
                      
                        Button {
                            //Load Route Screen
                            vm.analytics.viewedMission()
                            showMission.toggle()
                            
                        } label: {
                            Text("Start Mission")
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
                vm.analytics.viewedSecretSpot()
                DataService.instance.updatePostViewCount(postId: spot.id)
                vm.updateSecretSpot(postId: spot.id)
                vm.checkIfPresent(spot: spot)
            })
            .actionSheet(isPresented: $vm.showActionSheet, content: {
                getActionSheet()
            })
            .alert(isPresented: $showAlert) {
                return Alert(title: Text(alertMessage))
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            

        
        
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
