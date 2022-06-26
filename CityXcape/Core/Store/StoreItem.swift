//
//  StoreItem.swift
//  CityXcape
//
//  Created by James Allan on 6/12/22.
//

import SwiftUI

struct StoreItem: View {
    @EnvironmentObject private var store: Store
    var product: Product
    @StateObject var vm: StorePageViewModel
    
    let width = UIScreen.screenWidth

    @State private var showDetails: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        
        VStack {
            
            ZStack {
                Image(product.imageNames.first ?? "")
                    .resizable()
                    .scaledToFill()
                    .frame(width: width)
                
                detailsView
                
            }
            
            bottomTabBar
            
        }
        .frame(width: width, height: width + 80)
        .background(Color.dark_grey.opacity(0.9))
        .cornerRadius(12)
        
    }
}

extension StoreItem {
    
    
    private var detailsView: some View {
        VStack {
            Spacer()
            HStack {
                Text(product.description)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .opacity(showDetails ? 1 : 0)
        .animation(.easeOut, value: showDetails)

    }

    
    
    private var bottomTabBar: some View {
        HStack {
            
            Text(product.name)
                .font(.title)
                .fontWeight(.thin)
                .lineLimit(1)
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                showDetails.toggle()
            } label: {
                Image("info")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
            }
            
            Button {
                //Buy Logic
                if let product = store.product(for: product.id) {
                    store.purchaseProduct(product, completion: { result in
                        switch result {
                        case .success(_):
                            vm.alertMessage = "Successfully purchased 100 STC"
                            vm.showAlert.toggle()
                            vm.updateStreetCred()
                        case .failure(_):
                            vm.alertMessage = "StreetCred transaction failed!"
                            vm.showAlert.toggle()
                        }
                    })
                }
            } label: {
                Text(String(format: "%.2f", product.price))
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.black)
                    .cornerRadius(10)
            }
         
        }
        .padding(.horizontal, 10)
        .alert(isPresented: $vm.showAlert) {
            return Alert(title: Text(vm.alertMessage))
        }

    }

    
    
}

struct StoreItem_Previews: PreviewProvider {
    static var previews: some View {
        StoreItem(product: Product.demo, vm: StorePageViewModel())
            .previewLayout(.sizeThatFits)
    }
}
