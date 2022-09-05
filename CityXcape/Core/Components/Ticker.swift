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
    
    
    
    let width: CGFloat
    let searchTerm: String
    
    var body: some View {
        
        HStack {
           
          
            TextField(searchTerm, text: $searchText, onCommit: handlesearch)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .frame(width: width / 1.5)

            
        }
        .font(.headline)
        .overlay(
                  RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white, lineWidth: 0.5)
                    .frame(width: width / 1.5)
                  
              )
 
        
      
     
     
    }
  

    
}

struct Ticker_Previews: PreviewProvider {
    @State static var search: String = ""
    static let searchFunction: () -> () = {print("123")}
    static let width: CGFloat = 100

    static var previews: some View {
        Ticker(searchText: $search, handlesearch: searchFunction, width: width, searchTerm: "Search...")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
