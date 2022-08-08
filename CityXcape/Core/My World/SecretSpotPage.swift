//
//  SecretSpotPage.swift
//  CityXcape
//
//  Created by James Allan on 7/27/22.
//

import SwiftUI

struct SecretSpotPage: View {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    @Environment(\.presentationMode) var presentationMode
    
    var spot: SecretSpot
    var vm: DiscoverViewModel

    var width: CGFloat = UIScreen.screenWidth
    @State private var showActionsheet: Bool = false
    @State private var actionType: CardActionSheet = .general
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    @State private var detailsTapped: Bool = false
    @State private var saved: Bool = false
    @State private var pass: Bool = false
    
    
    let manager = CoreDataManager.instance
    
    var body: some View {
        VStack {
            
            ZStack {
                ImageSlider(images: spot.imageUrls)
                    .frame(height: width)
                
                DetailsView(spot: spot, showActionSheet: $showActionsheet, type: .CardView)
                    .opacity(detailsTapped ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: detailsTapped)
                
                
                LikeAnimationView(color: .cx_green, didLike: $saved, size: 200)
                    .opacity(saved ? 1 : 0)
                
            }
            .frame(height: width)
            
            bottomTab
            
            buttonRow
            
            Spacer()
            
            arrowButton
           
            
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.black,  Color.orange]), startPoint: .center, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

extension SecretSpotPage {
    
    
    private var bottomTab: some View {
        HStack {
            Image("pin_blue")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
                .opacity(detailsTapped ? 0 : 1)

            Text(spot.spotName)
                .font(.title)
                .fontWeight(.thin)
                .lineLimit(1)
                .opacity(detailsTapped ? 0 : 1)
                .foregroundColor(.white)

            Spacer()
            
            VStack {
                Button {
                    //TBD
                    if detailsTapped == false {
                        DataService.instance.updatePostViewCount(postId: spot.id)
                        AnalyticsService.instance.viewedDetails()
                    }
                    detailsTapped.toggle()
                } label: {
                    Image("info")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                        .padding(.leading, 4)
                        .animation(.easeOut, value: detailsTapped)
                        
                }
                
                Text(vm.getDistanceMessage(spot: spot))
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                
            }
         
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
        .animation(.easeOut(duration: 0.5), value: detailsTapped)
    }
    
    private var buttonRow: some View {
        HStack(spacing: 75) {
            
            Button {
                vm.dismissCard(spot: spot)
                presentationMode.wrappedValue.dismiss()
            } label: {
                VStack {
                    Image(systemName: "hand.thumbsdown.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .foregroundColor(.red)
                    
                    Text("Pass")
                        .font(.caption)
                        .fontWeight(.thin)
                        .foregroundColor(.red)
                }
            }
            
            Button {
                vm.saveCardToUserWorld(spot: spot)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                VStack {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .foregroundColor(.cx_green)
                    
                    Text("Save")
                        .font(.caption)
                        .fontWeight(.thin)
                        .foregroundColor(.cx_green)
                }
            }

        }
    }
    
    
  
    private var arrowButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("arrow")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .opacity(0.5)
        }
    }
    
    
   
    
    
    
    
    
}

struct SecretSpotPage_Previews: PreviewProvider {
    static var previews: some View {
        SecretSpotPage(spot: SecretSpot.spot, vm: DiscoverViewModel())
    }
}
