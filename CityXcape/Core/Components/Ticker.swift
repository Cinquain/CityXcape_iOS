//
//  Ticker.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct Ticker: View {

    let width: CGFloat = UIScreen.screenWidth
    @Binding var searchText: String
    var handlesearch: () -> ()
    var body: some View {
        
        HStack {
            Image("fire")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .background(Color.black)
                .clipShape(Circle())
            
            TextField("", text: $searchText, onCommit: handlesearch)
                .placeholder(when: searchText.isEmpty) {
                    Text("Search a spot or user").foregroundColor(.orange.opacity(0.7)).fontWeight(.thin)
            }
             

               
            
        }
        .font(.headline)
        .frame(width: width)
        .overlay(
                  RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.orange.opacity(0.7), lineWidth: 0.5)
              )
 
        
      
     
     
    }
  

    
}

struct Ticker_Previews: PreviewProvider {
    
    @State static var captions =  [
        "Welcome to CityXcape",
        "Find Secret Spots",
        "Keep Exploring!"
    ]
    @State static var search: String = ""
    static let searchFunction: () -> () = {print("123")}
    


    static var previews: some View {
       
        Ticker(searchText: $search, handlesearch: searchFunction)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
