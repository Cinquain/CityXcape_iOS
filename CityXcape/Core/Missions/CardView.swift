//
//  CardView.swift
//  CityXcape
//
//  Created by James Allan on 10/8/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View, Identifiable {
    
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?

    @State private var showStreetPass: Bool = false
    @State private var showComments: Bool = false
    @State private var showActionsheet: Bool = false
    @State private var actionType: CardActionSheet = .general
    @State private var detailsTapped: Bool = false
    
    var width = UIScreen.screenWidth - 15
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    var id: String {
        spot.id
    }
    var spot: SecretSpot
    var vm: SpotViewModel = SpotViewModel()
    
    
    var body: some View {
        
            ImageSlider(images: spot.imageUrls)
            .frame(height: UIScreen.screenHeight / 1.5)
                .cornerRadius(24)
                .overlay(
                    ZStack(alignment: .bottom) {
                        VStack(alignment: .center, spacing: 12) {
                                Text(spot.spotName)
                                    .font(.title)
                                    .fontWeight(.light)
                                    .shadow(radius: 1)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 4)
                                    .overlay (
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(height: 1)
                                        ,alignment: .bottom
                                )
                                .opacity(detailsTapped ? 0 : 1)
                                .animation(.easeOut(duration: 0.3), value: detailsTapped)

                            
                            Text(vm.getDistanceMessage(spot: spot))
                                .font(.footnote)
                                .foregroundColor(.black)
                                .fontWeight(.thin)
                                .frame(minWidth: 85)
                                .frame(maxWidth: 120)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule().fill(Color.white)
                                        .overlay(
                                            HStack {
                                                Image("pin_blue")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 12)
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                Image("pin_blue")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 12)
                                                    .foregroundColor(.black)
                                            }
                                            .padding(.horizontal, 5)
                                        )
                                )
                                .opacity(detailsTapped ? 0 : 1)
                                .animation(.easeOut(duration: 0.3), value: detailsTapped)



                        }
                        .foregroundColor(.white)
                        .frame(minWidth: 280)
                        .padding(.bottom, 50)
                        
                    DetailsView(spot: spot, type: .CardView)
                         .opacity(detailsTapped ? 1 : 0)
                         .animation(.easeOut(duration: 0.5), value: detailsTapped)
                         .cornerRadius(24)
                         .padding(.bottom, 20)
                         .clipped()
                        
                    }
                
                    
                    
                    
                    ,
                    alignment: .bottom
            )
            .onTapGesture {
                if detailsTapped == false {
                    DataService.instance.updatePostViewCount(postId: spot.id)
                    AnalyticsService.instance.viewedDetails()
                }
                detailsTapped.toggle()
            }
        
         

            //End of ZStack
        

        
      
    }
    
    
    fileprivate func loadActionSheet() -> ActionSheet {
        
        switch actionType {
        case .general:
            return ActionSheet(title: Text("Would you like to report this post?"), message: nil, buttons: [
            
                .destructive(Text("Report"), action: {
                    actionType = .report
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showActionsheet.toggle()
                    }
                }),
                
                .cancel()
    
            
            ])
        case .report:
            return ActionSheet(title: Text("Why are you reporting this post"), message: nil, buttons: [
                .destructive(Text("This is innapropriate"), action: {
                    reportPost(reason: "This is innapropriate", spot: spot)
                }),
                .destructive(Text("This is spam"), action: {
                    reportPost(reason: "This is spam", spot: spot)
                }),
                .destructive(Text("It made me uncomfortable"), action: {
                    reportPost(reason: "It made me uncomfortable", spot: spot)
                }),
                .cancel({
                    vm.actionSheetType = .general
                })
            ])
        }
        
    }
    
    
    func reportPost(reason: String, spot: SecretSpot) {
          print("Reporting post")
          AnalyticsService.instance.reportPost()
          DataService.instance.uploadReports(reason: reason, postId: spot.id) { success in
              
              if success {
                  alertMessage = "Thank you for reporting this spot. We will review it shortly!"
                  showAlert.toggle()
              } else {
                  alertMessage = "There was an error reporting this secret spot. Please restart the app and try again."
                  showAlert.toggle()
              }
          }

      }

}


extension CardView {
    
    private var bottomTab: some View {
        HStack {
          
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
                
            }
         
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
        .animation(.easeOut(duration: 0.5), value: detailsTapped)
    }
    

    
}

struct CardView_Previews: PreviewProvider {
    
    @State static var alert: Bool = false
    @State static var title: String = ""
    @State static var message: String = ""
    
    static var previews: some View {
        CardView(spot: SecretSpot.spot)
    }
}
