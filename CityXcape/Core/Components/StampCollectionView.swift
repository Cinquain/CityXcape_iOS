//
//  StampCollectionView.swift
//  CityXcape
//
//  Created by James Allan on 3/4/22.
//

import SwiftUI

struct StampCollectionView: View {
    
    let width = UIScreen.screenWidth * 0.90
    let height = UIScreen.screenHeight * 0.40
    let color = Color.random
    @State var rerender: Bool = false
    @StateObject var vm: JourneyViewModel
    
    var body: some View {
        
   
    ScrollView {
        TabView {
            
            ForEach(vm.cities.map({$0.key}), id: \.self) { city in
           
                Image("Stamp")
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        VStack(alignment: .center, spacing: 0) {
                            Text(city)
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.stamp_red)
                        }
                        .rotationEffect(Angle(degrees: -30))
                        )
                    
            }
                
                
            }
            .background(Color.black)
            .frame(width: width,
                   height: height)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .cornerRadius(5)
        }
        
        
    }
}

struct StampCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        StampCollectionView(vm: JourneyViewModel())

    }
}
