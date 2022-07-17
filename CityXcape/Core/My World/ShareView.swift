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
    var comment: String
    var body: some View {
        
        ZStack {
            AnimationView()
            
            VStack {
                Spacer()
                    .frame(height: width / 6)
                
                title
                
                StampImage(image: vm.journeyImage ?? UIImage(), title: spot.spotName, date: Date(), comment: comment)
                    .frame(width: 500, height: 500)
                    .clipped()

                 
                VStack(spacing: 0) {
                    Text("Share")
                        .font(Font.custom("Savoye LET", size: 35))
                        .foregroundColor(.white)
                    HStack {
                        shareButton
                        instagramButton
                    }
                }

                
                Spacer()
                
                downArrow
            
                
            }
            
            //End of ZStack
        }
        .background(.black)
        .edgesIgnoringSafeArea(.all)
    
    }
}


extension ShareView {
    
    private var title: some View {
        Text("Congratulationss! \n You verified \(spot.spotName)")
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
    }
    
    private var shareButton: some View {
        Button {
            vm.shareStampImage(spot: spot)
       } label: {
 
           Image("text_share")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 40)
            
        }
       .sheet(isPresented: $vm.showShareSheet) {
           ShareSheetView(photo: vm.stampImage ?? UIImage(), title: spot.spotName)
       }
    }
    
    private var instagramButton: some View {
        Button {
            //TBD
            vm.shareInstaStamp(spot: spot)
        } label: {
            Image("ig_share")
                 .renderingMode(.template)
                 .resizable()
                 .scaledToFit()
                 .foregroundColor(.white)
                 .frame(width: 40)
        }

    }
    
    private var downArrow: some View {
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
    
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(vm: SpotViewModel(), spot: SecretSpot.spot, comment: "Awesome!")
    }
}
