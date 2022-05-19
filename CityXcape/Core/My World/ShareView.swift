//
//  ShareView.swift
//  CityXcape
//
//  Created by James Allan on 5/7/22.
//

import SwiftUI

struct ShareView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: SpotViewModel
    @State var spot: SecretSpot
    var width: CGFloat = UIScreen.screenWidth

    var body: some View {
        
        ZStack {
            AnimationView()
            
            VStack {
                Spacer()
                    .frame(height: width / 4)
                
                
                Text("Congratulations! \n You verified \(spot.spotName)")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                
                StampImage(width: width, height: width, image: vm.journeyImage ?? UIImage(named: "magic garden")!, title: spot.spotName, date: Date())
                
                HStack {
                    
                    Button {
                        vm.shareStampImage(spot: spot)
                        vm.showShareSheet.toggle()
                    } label: {
                        VStack(spacing: 0) {
                            Image("share")
                                 .resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .frame(width: 50)
                        }
                    }
                    .sheet(isPresented: $vm.showShareSheet) {
                        ShareSheetView(photo: vm.generateStampImage(spot: spot))
                    }
                    
                    Button {
                        vm.shareInstaStamp(spot: spot)
                    } label: {
                        VStack(spacing: 0) {
                            Image("iG")
                                 .resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .frame(width: 50)
                        }
                    }
                
                }
                .padding()
                
                Spacer()
                
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
                .padding()
            }
            
            //End of ZStack
        }
        .background(.black)
        .edgesIgnoringSafeArea(.all)
    
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(vm: SpotViewModel(), spot: SecretSpot.spot)
    }
}
