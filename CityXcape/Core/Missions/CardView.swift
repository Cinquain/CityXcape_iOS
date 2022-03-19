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
    var width = UIScreen.screenWidth - 15
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    
    var spot: SecretSpot
    var vm: SpotViewModel = SpotViewModel()
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            WebImage(url: URL(string: spot.imageUrls.first ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width)
                .overlay(
                    ZStack {
                        LinearGradient(colors: [Color.clear, Color.black], startPoint: .center, endPoint: .bottom)
                     
                        VStack {
                            Spacer()
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
                        }
                    }
                )
            

            
            
            
            
            HStack(spacing: 10) {
                
                Button {
                    alertMessage = "You must save this spot to see its address."
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
                    alertMessage = "You must save this spot to see the users who saved it"
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
                    //To be continued
                    showStreetPass.toggle()
                    AnalyticsService.instance.viewStreetpass()
                } label: {
                    
                    VStack(spacing: 0) {
                        UserDotView(imageUrl: spot.ownerImageUrl, width: 25, height: 25)
                        Text(spot.ownerDisplayName)
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                }
                
                Spacer()
                
                Button {
                    //TBD
                    alertMessage = "This spot will cost you \(spot.price) streetcred to save. You have \(wallet ?? 0) STC remaining"
                    showAlert.toggle()
                } label: {
                    VStack {
                        Text("\(spot.price)")
                            .font(.title2)
                            .fontWeight(.light)
                            .frame(width: 20)
                            .foregroundColor(.cx_green)

                        
                        Text("STC")
                            .font(.caption)
                            .fontWeight(.thin)
                            .foregroundColor(.cx_green)
                    }
                }

                
                

            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            
            Text(spot.description ?? "")
                .fontWeight(.thin)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .lineLimit(3)
                .padding(.bottom, 20)
            
         
            
            

        }
        .alert(isPresented: $showAlert) {
            return Alert(title: Text(alertMessage), message: nil)
        }
        .frame(width: width)
        .background(Color.black)
        .cornerRadius(10)
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
    static var secretspot = SecretSpot(postId: "1234", spotName: "The Eichler Home", imageUrls: ["https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/missions%2Fexplore.jpg?alt=media&token=474e3d92-bf7a-4ce0-afc9-f996d5f96fd9"], longitude: 39.784352, latitude: -86.093180, address: "1229 Spann Ave", description: "This is the best spot in the world", city: "Indianapolis", zipcode: 46203, world: "Surfers", dateCreated: Date(), price: 1, viewCount: 4, saveCounts: 30, isPublic: true, ownerId: "Cinquain", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FhotK4d2IZDYs0wjlKc3A%2FprofileImage?alt=media&token=57e6e26b-ffef-4d31-be3a-db599c4c97a9", likeCount: 10, didLike: false, verifierCount: 0)
    
    static var previews: some View {
        CardView(showAlert: $alert, alertMessage: $message, spot: secretspot)
    }
}
