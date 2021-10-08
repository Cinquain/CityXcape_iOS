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
    @State private var alertmessage: String = ""
    @State private var alertTitle: String = ""
    var captions: [String] = [String]()
    var spot: SecretSpot?
    
    @State private var showActionSheet: Bool = false
    @State private var genericAlert: Bool = false
    @State private var actionSheetType: SpotActionSheetType = .general

    
    
    init(spot: SecretSpot) {
        self.spot = spot
        let name = spot.spotName
        let distanceString = String(format: "%.1f", spot.distanceFromUser)
        let distance = spot.distanceFromUser > 1 ? "\(distanceString) miles away" : "\(distanceString) mile away"
        let postedby = "Posted by \(spot.ownerDisplayName)"
        
        captions.append(contentsOf: [name, distance, postedby])
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    Ticker(profileUrl: spot?.ownerImageUrl ?? "", captions: captions)
                        .frame(height: 120)
                    
                    WebImage(url: URL(string: spot?.imageUrl ?? ""))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 20)
                    
                    Text(spot?.description ?? "")
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .lineLimit(.none)
                        .padding()
                    
                    Button(action: {
                        openGoogleMap()
                    }, label: {
                        HStack {
                            Image("pin_blue")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            Text(spot?.address ?? "")
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
                    }
                    
                }
                .foregroundColor(.accent)
                
            }
            .colorScheme(.dark)
            .alert(isPresented: $genericAlert, content: {
                return Alert(title: Text(alertTitle), message: Text(alertmessage), dismissButton: .default(Text("Ok")))
            })
            .actionSheet(isPresented: $showActionSheet, content: {
                getActionSheet()
            })
        }
        
    }
    
    func openGoogleMap() {
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(spot!.latitude),\(spot!.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
            
        } else {
            //Open in brower
            if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(spot!.latitude),\(spot!.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url)
            }
            
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
                    reportPost(reason: "This is innapropriate")
                }),
                .destructive(Text("This is spam"), action: {
                    reportPost(reason: "This is spam")
                }),
                .destructive(Text("It made me uncomfortable"), action: {
                    reportPost(reason: "It made me uncomfortable")
                }),
                .cancel( {
                    self.actionSheetType = .general
                })
            ])
        case .delete:
            return ActionSheet(title: Text("Are You sure you want to delete this post?"), message: nil, buttons: [
                .destructive(Text("Yes"), action: {
                    deletePost()
                }),
                
                .cancel(Text("No"))
            ])
        }
    }
  
    func reportPost(reason: String) {
        print("Reporting post")
        guard let postId = spot?.postId else {return}
        DataService.instance.uploadReports(reason: reason, postId: postId) { success in
            
            if success {
                self.alertTitle = "Successfully Reported"
                self.alertmessage = "Thank you for reporting this spot. We will review it shortly!"
                self.genericAlert.toggle()
            } else {
                self.alertTitle = "Error Reporting Spot"
                self.alertmessage = "There was an error reporting this secret spot. Please restart the app and try again."
                self.genericAlert.toggle()
            }
        }
    }
    
     func deletePost() {
        guard let postId = spot?.postId else {return}
        
        DataService.instance.deleteSecretSpot(spotId: postId) { success in
            
            if success {
                self.alertTitle = "Successfully Deleted"
                self.alertmessage = "This secret spot has been removed from your world"
                self.genericAlert.toggle()
                self.presentationMode.wrappedValue.dismiss()
            } else {
                self.alertTitle = "Error"
                self.alertmessage = "There was an error in deleting this spot. Restart the app and try again"
                self.genericAlert.toggle()
            }
        }
    }
    
}

//struct SpotDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let spot = SecretSpot(postId: "disnf", spotName: "The Big Duck", imageUrl: "big", longitude: 1010, latitude: 01202, address: "1229 Spann avenue", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), viewCount: 1, price: 1, saveCounts: 1, description: "The best spot", ownerId: "wjffh", ownerDisplayName: "Cinquain", ownerImageUrl: "Eichler")
//
//        SpotDetailsView(spot: spot)
//    }
//}
