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
                                
                                VStack {
                                    if spot.distanceFromUser < 10 {
                                        Image("walking")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                    }
                                    Text(vm.getDistanceMessage(spot: spot))
                                        .font(.caption)
                                        .fontWeight(.thin)
                                    
                                }
                             
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 5)
                        }
                    }
                )
            

            
            
            
            
            HStack(spacing: 10) {

                Button {
                    //To be continued
                    showStreetPass.toggle()
                    AnalyticsService.instance.viewStreetpass()
                } label: {
                    
                    VStack(spacing: 0) {
                        UserDotView(imageUrl: spot.ownerImageUrl, width: 25)
                        Text(spot.ownerDisplayName)
                            .font(.caption)
                            .fontWeight(.thin)
                            .lineLimit(1)
                            .frame(width: 50)
                    }
                }
                
                
                Button {
                    showActionsheet.toggle()
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "flag.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                        
                        Text("Report")
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                    .foregroundColor(.red)
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

struct CardView_Previews: PreviewProvider {
    
    @State static var alert: Bool = false
    @State static var title: String = ""
    @State static var message: String = ""
    
    static var previews: some View {
        CardView(showAlert: $alert, alertMessage: $message, spot: SecretSpot.spot)
    }
}
