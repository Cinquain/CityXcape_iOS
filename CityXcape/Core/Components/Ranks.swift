//
//  Ranks.swift
//  CityXcape
//
//  Created by James Allan on 3/21/22.
//

import SwiftUI

struct Ranks: View {
    
    let width: CGFloat = UIScreen.screenWidth
    
    var body: some View {
        
        VStack {
            
            HStack {
                Spacer()
                Text("Scout Levels")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.thin)
                Spacer()
            }
            
            Spacer()
                .frame(height: 20)
            HStack {
                Text("Rank")
                    .font(.title3)
                    .fontWeight(.thin)
                    .frame(width: 90)
                
                Divider()
                    .background(Color.white)
                    .frame(width: 1, height: 20)
                
                Text("Requirement")
                    .font(.title3)
                    .fontWeight(.thin)
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .foregroundColor(.cx_orange)
            ScrollView {
                ForEach(Level.ranks) { rank in
                    
                    HStack( spacing: 10) {
                        VStack {
                            Image(rank.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                               
                            Text(rank.id)
                                .font(.caption)
                                .fontWeight(.thin)
                        }
                        .frame(width: 100)
                        

                       
                        
                        Text(rank.requirement)
                            .font(.subheadline)
                            .fontWeight(.thin)
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    
                    Divider()
                        .background(Color.white)
                        .frame(width: width, height: 0.5)
                }
            }
            
            Spacer()
                .frame(height: 20)
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct Ranks_Previews: PreviewProvider {
    static var previews: some View {
        Ranks()
    }
}
