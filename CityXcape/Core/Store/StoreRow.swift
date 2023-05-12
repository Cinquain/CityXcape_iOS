//
//  StoreRow.swift
//  CityXcape
//
//  Created by James Allan on 6/12/22.
//

import SwiftUI

struct StoreRow: View {
    
    var product: Product
    
    
    
    var body: some View {
        
        buttonLabel
        

    }
    
}



extension StoreRow {
    
    private var buttonLabel: some View {
        HStack {
            
            Image("StoreSTC")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .cornerRadius(12)
            
            Text("100 StreeCred")
                .fontWeight(.thin)
                .foregroundColor(.white)
            
            Spacer()
            
            Text("$9.99")
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(.black)
                .cornerRadius(10)
            
        }
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.dark_grey.opacity(0.8))
        .cornerRadius(12)
    }
}

struct StoreRow_Previews: PreviewProvider {
    @State static var showItem: Bool = false
    static var previews: some View {
        StoreRow(product: Product.demo)
            .previewLayout(.sizeThatFits)

    }
}
