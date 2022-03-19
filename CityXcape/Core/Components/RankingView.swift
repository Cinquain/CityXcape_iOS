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
    
    var uid: String
    var progress: CGFloat
    var rank: Int
    @State private var showStreetPass: Bool = false
    
    
    var body: some View {
        
        HStack {
            
            
            HStack(spacing: 15) {
                Text("\(rank)")
                    .fontWeight(.thin)
                    .font(.title)
                    .foregroundColor(uid == userId ? .cx_orange : .white)


                Button {
                    //TBD
                    showStreetPass.toggle()
                } label: {
                    
                    VStack(spacing: 0) {
                        UserDotView(imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", width: 70, height: 70)
                        
                        Text("Cinquain")
                            .foregroundColor(uid == userId ? .cx_orange : .white)
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                }
                .sheet(isPresented: $showStreetPass) {
                    BarView(progress: 100)
                }


            }
            .foregroundColor(.white)
            .padding(.leading, 8)
            
            
            VStack(spacing: 5) {
                BarView(progress: progress)
                HStack {
                    Spacer()
                    
                    Text("Next Level: Scout")
                        .foregroundColor(uid == userId ? .cx_orange : .white)
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
        .background(uid == userId ? Color.dark_grey : Color.clear)
        .cornerRadius(8)
        
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView(uid: "abcy", progress: 125, rank: 1)
            .previewLayout(.sizeThatFits)
    }
}
