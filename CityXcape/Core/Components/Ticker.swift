//
//  Ticker.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct Ticker: View {

    @Binding var searchText: String
    var handlesearch: () -> ()
    
    
    
    let width: CGFloat = UIScreen.screenWidth
    var body: some View {
        
        HStack {
            Image("cx")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .background(Color.black)
                .clipShape(Circle())
            
            TextField("Search...", text: $searchText, onCommit: handlesearch)
               
            
        }
        .font(.headline)
        .frame(width: width)
        .overlay(
                  RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white, lineWidth: 0.5)
                  
              )
 
        
      
     
     
    }
  

    
}

struct Ticker_Previews: PreviewProvider {
    @State static var search: String = ""
    static let searchFunction: () -> () = {print("123")}

    static var previews: some View {
       
        Ticker(searchText: $search, handlesearch: searchFunction)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
