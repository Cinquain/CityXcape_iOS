//
//  Leaderboard.swift
//  CityXcape
//
//  Created by James Allan on 3/17/22.
//

import SwiftUI

struct Leaderboard: View {
    
    var width: CGFloat = UIScreen.screenWidth * 0.8
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Top Scouts")
                    .font(Font.custom("Lato", size: 40))
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                .tracking(10)
                Spacer()
            }
        

            ScrollView {
                ForEach(1..<10) { num in
                    RankingView(uid: "abc", progress: min(200,CGFloat(num * 35)), rank: num)
                    
                    Divider()
                        .frame(width: width, height: 0.5)
                        .background(Color.white)
                    
                    
                }
                
            }
            
            
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
        .background( LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: .black, location: 0.40),
            Gradient.Stop(color: .cx_orange, location: 3.0),
        ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        Leaderboard()
    }
}
