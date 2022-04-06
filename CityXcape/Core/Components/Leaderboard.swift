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
    
    @State var ranks: [Ranking]

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
                ForEach(0..<ranks.count) { index in
                    RankingView(rank: ranks[index], index: index + 1, userSize: 70)
                    
                    Divider()
                        .frame(width: width, height: 0.5)
                        .background(Color.white)
                    
                    
                }
                
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
        Leaderboard(ranks: [])
    }
}
