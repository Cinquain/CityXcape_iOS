//
//  CardView.swift
//  CityXcape
//
//  Created by James Allan on 10/8/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View {
    
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?

    @State private var showStreetPass: Bool = false
    @State private var showComments: Bool = false
    @State private var showActionsheet: Bool = false
    @State private var actionType: CardActionSheet = .general
    @State private var detailsTapped: Bool = false
    
    var width = UIScreen.screenWidth - 15
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    
    var spot: SecretSpot
    var vm: SpotViewModel = SpotViewModel()
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            ZStack {
                
                ImageSlider(images: spot.imageUrls)
                    .frame(width: width)
                
                DetailsView(spot: spot, showActionSheet: $showActionsheet, type: .CardView)
                    .opacity(detailsTapped ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: detailsTapped)
                
            }
            
            bottomTab

            
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
            let user = User(spot: spot)
            PublicStreetPass(user: user)
        }
        .actionSheet(isPresented: $showActionsheet) {
            loadActionSheet()
        }

        
      
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
        CardView(showAlert: $alert, alertMessage: $message, spot: SecretSpot.spot)
    }
}
