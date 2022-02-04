//
//  CardView.swift
//  CityXcape
//
//  Created by James Allan on 10/8/21.
//

import SwiftUI
import Shimmer
import SDWebImageSwiftUI

struct CardView: View {
    
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?

    @State private var showStreetPass: Bool = false
    @State private var showComments: Bool = false
    
    @Binding var showAlert: Bool
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    var spot: SecretSpot
    var vm: SpotViewModel = SpotViewModel()
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            WebImage(url: URL(string: spot.imageUrls.first ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
            
            Divider()
                .background(Color.white)
            
            
            HStack(spacing: 10) {
                
                Button {
                    alertTitle = ""
                    alertMessage = "You must save this spot get its address. Swipe right to save"
                    showAlert.toggle()
                } label: {
                    VStack {
                        Image("walking")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                        Text(vm.getDistanceMessage(spot: spot))
                            .font(.caption)
                            .fontWeight(.thin)
                        
                    }
                    
                }
                
                Button {
                    alertTitle = ""
                    alertMessage = "This spot belongs to \(spot.world) community"
                    showAlert.toggle()
                } label: {
                    VStack {
                        Image("globe")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                        
                        Text(spot.world)
                            .font(.caption)
                            .fontWeight(.thin)
                            .lineLimit(1)
                            .frame(width: 40)

                    }
                }
                
                Button {
                    alertTitle = ""
                    alertMessage = "You must save this spot to see the other users who saved it"
                    showAlert.toggle()
                } label: {
                    VStack {
                        Image("dot")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                        
                        Text(vm.getSavesMessage(spot: spot))
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                }


                
                Button {
                    //Open comments view
                    vm.getComments(postId: spot.id)
                    AnalyticsService.instance.viewedComments()
                    showComments.toggle()
                } label: {
                    VStack {
                        Image(systemName: "bubble.left.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                        Text("Comments")
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                }
                .sheet(isPresented: $showComments) {
                    CommentsView(spot: spot, vm: vm)
                }
                
                Spacer()
                
                Button {
                    //TBD
                    alertTitle = ""
                    alertMessage = "This spot will cost you \(spot.price) streetcred to save. You have \(wallet ?? 0) STC remaining"
                    showAlert.toggle()
                } label: {
                    VStack {
                        Text("\(spot.price)")
                            .font(.title2)
                            .fontWeight(.light)
                            .frame(width: 20)
                        
                        Text("STC")
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                }

                
                

            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            
            Text(spot.description ?? "")
                .fontWeight(.thin)
                .padding(.horizontal, 40)
                .padding(.top, 20)
                .lineLimit(3)
            Spacer()
            
            HStack(alignment: .top) {
                Image("pin_blue")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .padding(.bottom, 10)
                
                Text(spot.spotName)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .font(.title2)
                    .padding(.top, 5)
                
                Spacer()
                
                Button {
                    //To be continued
                    showStreetPass.toggle()
                    AnalyticsService.instance.touchedProfile()
                } label: {
                    
                    VStack(spacing: 0) {
                        UserDotView(imageUrl: spot.ownerImageUrl, width: 25, height: 25)
                        Text(spot.ownerDisplayName)
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                }
                
            }
            .padding(.horizontal, 20)

        }
        .alert(isPresented: $showAlert) {
            return Alert(title: Text(alertMessage), message: nil)
        }
        .frame(width: 350, height: 520)
        .background(Color.black)
        .cornerRadius(20)
        .foregroundColor(.white)
        .sheet(isPresented: $showStreetPass) {
            //TBD
            
        } content: {
            //TBD
            let user = User(id: spot.ownerId, displayName: spot.ownerDisplayName, profileImageUrl: spot.ownerImageUrl)
            PublicStreetPass(user: user)
        }

        
      
    }

}

struct CardView_Previews: PreviewProvider {
    
    @State static var alert: Bool = false
    @State static var title: String = ""
    @State static var message: String = ""
    static var secretspot = SecretSpot(postId: "1234", spotName: "The Eichler Home", imageUrls: ["https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/missions%2Fexplore.jpg?alt=media&token=474e3d92-bf7a-4ce0-afc9-f996d5f96fd9"], longitude: 39.784352, latitude: -86.093180, address: "1229 Spann Ave", description: "This is the best spot in the world", city: "Indianapolis", zipcode: 46203, world: "Surfers", dateCreated: Date(), price: 1, viewCount: 4, saveCounts: 30, isPublic: true, ownerId: "Cinquain", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FhotK4d2IZDYs0wjlKc3A%2FprofileImage?alt=media&token=57e6e26b-ffef-4d31-be3a-db599c4c97a9")
    static var previews: some View {
        CardView(showAlert: $alert, alertTitle: $title, alertMessage: $message, spot: secretspot)
    }
}
