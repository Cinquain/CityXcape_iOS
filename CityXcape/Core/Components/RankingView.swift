//
//  RankingView.swift
//  CityXcape
//
//  Created by James Allan on 3/18/22.
//

import SwiftUI

struct RankingView: View {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?

    let width = UIScreen.screenWidth * 0.90
    let height: CGFloat = 100
     
    var rank: Ranking
    var index: Int
    
    @State private var showStreetPass: Bool = false
    
    
    var body: some View {
        
        HStack {
            
            
            HStack(spacing: 15) {
                Text("\(index)")
                    .fontWeight(.thin)
                    .font(.title)
                    .foregroundColor(.white)


                Button {
                    //TBD
                    showStreetPass.toggle()
                } label: {
                    
                    VStack(spacing: 0) {
                        UserDotView(imageUrl: rank.profileImageUrl, width: 70, height: 70)
                        
                        Text(rank.displayName)
                            .foregroundColor(.white)
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                }
                .sheet(isPresented: $showStreetPass) {
                    BarView(progress: rank.progress)
                }


            }
            .foregroundColor(.white)
            .padding(.leading, 8)
            
            
            VStack(spacing: 5) {
                BarView(progress: rank.progress)
                HStack {
                    Spacer()
                    
                    Text("\(rank.totalSpots) spots posted")
                        .foregroundColor(.white)
                        .font(.caption)
                        .fontWeight(.thin)
                        .padding(.trailing, 15)

                }
                .frame(width: 200)
            }
            
         
        
            Spacer()
            
           

            //End of view
        }
        .frame(width: width, height: height)
        .background(Color.clear)
        .cornerRadius(8)
        
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        let rank = Ranking(id: "abc", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", displayName: "Cinquain", streetCred: 23, streetFollowers: 10, bio: "Yolo", currentLevel: "Scout", totalSpots: 30, totalStamps: 40, totalSaves: 40, totalUserVerifications: 30, totalPeopleMet: 0, totalCities: 10, progress: 30)
        
        RankingView(rank: rank, index: 1)
            .previewLayout(.sizeThatFits)
    }
}
