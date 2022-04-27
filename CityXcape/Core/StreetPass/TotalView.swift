//
//  TotalView.swift
//  CityXcape
//
//  Created by James Allan on 3/23/22.
//

import SwiftUI

struct TotalView: View {
    
    let type: AnalyticsType
    let width: CGFloat = UIScreen.screenWidth * 0.90
    @StateObject var vm: TotalsViewModel = TotalsViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showView: Bool = false
    @State var spots: [SecretSpot]
    @State var currentSpot: SecretSpot?
    @State var userViewSpot: SecretSpot?
    var body: some View {
        
        VStack {
            HStack {
                
                Image(vm.getImageName(type: type))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                
                Text(vm.getTitle(type: type))
                    .font(Font.custom("Lato", size: 30))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: 30)
            
            HStack {
                Text("Spot Name")
                    .font(.title3)
                    .fontWeight(.thin)
                
                Spacer()
                
                Image(systemName: vm.imageName(type: type))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .opacity(0.5)
                
                Text(type.rawValue)
                    .fontWeight(.thin)
            }
            .padding(.horizontal, 20)
            .foregroundColor(.white)

            
            ScrollView {
                ForEach(spots) { spot in
                    
                    Button {
                        //TBD
                        vm.handleButton(type: type, spot: spot)
                        if type == .views {
                            currentSpot = spot
                        } else {
                            userViewSpot = spot
                        }
                    } label: {
                        HStack {
                            SecretSpotView(width: 60, height: 60, imageUrl: spot.imageUrls.first ?? "")
                            
                            Text("\(spot.spotName)")
                                .fontWeight(.thin)
                            
                            Spacer()
                            
                            Text(vm.getCount(type: type, spot: spot))
                                .fontWeight(.thin)
                                .padding(.trailing, 20)
                                
                        }
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .sheet(item: $userViewSpot) { spot in
                        UserReportView(vm: vm, spot: spot, type: type)
                    }
                    
                    Divider()
                        .background(Color.white)
                        .frame(width: width, height: 0.5)
                        .sheet(item: $currentSpot) { spot in
                            EditSpotView(spot: spot)
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
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    
    
    
}

struct TotalView_Previews: PreviewProvider {
    static var previews: some View {
        TotalView(type: .views, spots: [])
    }
}

