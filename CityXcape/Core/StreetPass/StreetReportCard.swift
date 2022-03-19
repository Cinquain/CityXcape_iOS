//
//  StreetReportCard.swift
//  CityXcape
//
//  Created by James Allan on 3/19/22.
//

import SwiftUI

struct StreetReportCard: View {
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    
    
    var body: some View {
        
        VStack {
            
            HStack {
                VStack {
                    UserDotView(imageUrl: profileUrl ?? "", width: 80, height: 80)
                    Text(displayName ?? "")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                }
                .padding(.leading, 10)
                
                VStack(spacing: 0) {
                    Text("STREET")
                        .tracking(5)
                        .font(Font.custom("Lato", size: 20))
                        .foregroundColor(.white)
                    
                    Text("Report Card")
                        .font(Font.custom("Lato", size: 35))
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                    
                }
                
                Spacer()
            }
            
            ForEach(1..<4) { num in
                RankingView(uid: "acb", progress: CGFloat(min(200, 50 * num)), rank: num)
            }
            
            HStack {
                Image("graph")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                
                Text("Analytics")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                
            }
            .padding(.top, 50)
            
            VStack {
                
                Button {
                    //TBD
                } label: {
                    HStack {
                        Text("1,200 Views")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        Spacer()
                        Image(systemName: "eye.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.white)
                        
                    }
                    .frame(width: 180)

                }
                //Button 1
                
                Button {
                    //TBD
                } label: {
                    HStack {
                        Text("120 Saves")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        Spacer()
                        Image("dot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.white)
                        
                    }
                    .frame(width: 180)

                }
                .padding()
                //Button 1
                
                Button {
                    //TBD
                } label: {
                    HStack {
                        Text("12 Checkins")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        Spacer()
                        Image("checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.white)
                        
                    }
                    .frame(width: 180)
                }
                //Button 1

                
                
            }
            .padding(.top, 20)
            Spacer()
            
            
        }
        .background(LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: .black, location: 0.40),
            Gradient.Stop(color: .cx_orange, location: 3.0),
        ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

struct StreetReportCard_Previews: PreviewProvider {
    static var previews: some View {
        StreetReportCard()
    }
}
