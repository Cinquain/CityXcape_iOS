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

    var captions: [String] = [String]()
    var spot: SecretSpot
    
    @ObservedObject var vm: SpotViewModel = SpotViewModel()
    
    @State private var showActionSheet: Bool = false
    @State private var actionSheetType: SpotActionSheetType = .general
    @Binding var currentIndex: Int
    
 
    init(spot: SecretSpot, index: Binding<Int>) {
        self.spot = spot
        let name = spot.spotName
        let distanceString = String(format: "%.1f", spot.distanceFromUser)
        let distance = spot.distanceFromUser > 1 ? "\(distanceString) miles away" : "\(distanceString) mile away"
        let postedby = "Posted by \(spot.ownerDisplayName)"
        self._currentIndex = index
        captions.append(contentsOf: [name, distance, postedby])
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    Ticker(profileUrl: spot.ownerImageUrl, captions: captions)
                        .frame(height: 120)
                    
                    WebImage(url: URL(string: spot.imageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 20)
                    
                    Text(spot.description ?? "")
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .lineLimit(.none)
                        .padding()
                    
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
                    .padding(.leading, 20)
                    
                    
                    HStack {
                        Button(action: {
                            showActionSheet.toggle()
                        }, label: {
                            Image(systemName: "ellipsis")
                                .font(.title)
                                .foregroundColor(.white)
                        })
                        .padding()
                    
                        
                        Spacer()
                        
                        Button {
                            vm.checkInSecretSpot(spot: spot)
                        } label: {
                            VStack {
                                Image(Icon.check.rawValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 25)
                                
                                Text("check-in")
                                    .foregroundColor(.white)
                                    .fontWeight(.light)
                                    .font(.caption)
                            }
                        }
                        .padding(.trailing, 20)
                        .disabled(vm.disableCheckin)

                    }
                    
                }
                .foregroundColor(.accent)
                
            }
            .colorScheme(.dark)
            .onAppear(perform: {
                AnalyticsService.instance.viewedSecretSpot()
                DataService.instance.updatePostViewCount(postId: spot.postId)
            })
            .alert(isPresented: $vm.genericAlert, content: {
                return Alert(title: Text(vm.alertTitle), message: Text(vm.alertmessage), dismissButton: .default(Text("Ok"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                }))
            })
            .actionSheet(isPresented: $showActionSheet, content: {
                getActionSheet()
            })
            

        }
        
    }
    
    
    func getActionSheet() -> ActionSheet {
        switch actionSheetType {
            case .general:
            return ActionSheet(title: Text("What would you like to do"), message: nil, buttons: [
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
                
                .cancel(Text("No"))
            ])
        }
    }
  
    
}


struct SpotDetailsView_Previews: PreviewProvider {
    @State static var integer: Int = 1

    static var previews: some View {

        
        let spot = SecretSpot(postId: "disnf", spotName: "The Big Duck", imageUrl: "big", longitude: 1010, latitude: 01202, address: "1229 Spann avenue", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), viewCount: 1, price: 1, saveCounts: 1, isPublic: true, description: "The best spot", ownerId: "wjffh", ownerDisplayName: "Cinquain", ownerImageUrl: "https://twitter.com/TEA5E/status/570946413602799617/photo/1")

        SpotDetailsView(spot: spot, index: $integer)
    }
}
