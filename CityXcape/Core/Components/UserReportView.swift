//
//  UserReportView.swift
//  CityXcape
//
//  Created by James Allan on 3/24/22.
//

import SwiftUI

struct UserReportView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: TotalsViewModel
    var spot: SecretSpot
    var type: AnalyticsType
    
    var body: some View {
        VStack {
            HStack {
                
                SecretSpotView(width: 70, height: 70, imageUrl: spot.imageUrls.first ?? "")
               
                VStack {
                    Text(vm.getTitle(type: type))
                        .font(Font.custom("Lato", size: 35))
                    Text(spot.spotName)
                        .fontWeight(.thin)
                        .tracking(4)

                }
                    
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            
            Spacer().frame(height: 50)
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    ForEach(vm.saveUsers) { user in
                        
                        HStack {
                            VStack(spacing: 0) {
                                UserDotView(imageUrl: user.profileImageUrl, width: 120, height: 120)
                                
                                Text(user.displayName)
                                    .fontWeight(.thin)
                              
                            }
                            .foregroundColor(.white)
                            
                            Text(vm.timeStamp(type: type, user: user))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                  
                        
                        Spacer().frame(height: 30)
                    }
                    
                    //End of ForEach 
                }
                
                
                
            }
          
            
            Spacer()
            
            
        }
        .background(LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: .black, location: 0.40),
            Gradient.Stop(color: .cx_orange, location: 3.0),
        ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

struct UserReportView_Previews: PreviewProvider {
    static var previews: some View {
        UserReportView(vm: TotalsViewModel(), spot: SecretSpot.spot, type: .checkins)
    }
}
