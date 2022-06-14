//
//  StorePage.swift
//  CityXcape
//
//  Created by James Allan on 6/12/22.
//

import SwiftUI

struct StorePage: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: StorePageViewModel = StorePageViewModel()
    @State private var showItem: Bool = false
    @State private var currentProduct: Product?
    
    var products: [Product] = [Product.demo]
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Text("CX Store")
                    .fontWeight(.thin)
                    .font(.title)
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            
            if showItem {
                if let product = currentProduct {
                    StoreItem(product: product, vm: vm)
                        .animation(.easeOut(duration: 0.4), value: showItem)
                }
            }
        
            
            
            ScrollView {
                
                ForEach(products) { product in
                    Button {
                        showItem.toggle()
                        currentProduct = product
                    } label: {
                        StoreRow(product: product)
                    }
                  
                }
            

                    
            }
            
            Button {
                //
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .opacity(0.5)
            }
            
        }
        .background(LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: .black, location: 0.40),
            Gradient.Stop(color: .cx_orange, location: 3.0),
        ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

struct StorePage_Previews: PreviewProvider {
    static var previews: some View {
        StorePage()
    }
}
