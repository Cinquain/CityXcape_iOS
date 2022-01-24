//
//  SwipeView.swift
//  CityXcape
//
//  Created by James Allan on 10/8/21.
//

import SwiftUI
import CardStack

struct SwipeView: View {
    
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @Environment(\.presentationMode) var presentationMode

    
    @StateObject var vm: MissionViewModel
    
    @State private var opacity: Double = 0
    @State private var passed: Bool = false
    @State private var saved: Bool = false
    @State private var complete: Bool = false
    @State private var showAlert: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    
    @State var captions: [String] = [
        "Save the spots you want to visit",
        "Swipe right to save spot",
        "Check Streetpass to see StreetCred",
    ]
    
    var body: some View {
    
    
        VStack(spacing: 0) {
            Ticker(profileUrl: profileUrl ?? "", captions: $captions)
                .padding(.top, 25)
                .frame(height: 40)
        
 
            ZStack {
                Image("Scout")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 100)
                    .opacity(0.1)
                
                if saved {
                    VStack {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Saved to Your World!")
                        Text("\(wallet ?? 0) StreetCred Remaining")
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .padding(.top, -10)
                    }
                    .foregroundColor(.green)
                    .animation(.easeInOut)
                }
                
                if passed {
                    VStack {
                        Image(systemName: "hand.thumbsdown.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Passed!")
                    }
                    .foregroundColor(.red)
                    .animation(.easeInOut)
                }

            }
   
            
            if complete {
                Image("pin_blue")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .opacity(opacity)
                    .animation(.easeInOut)
                Text("No More Spots")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .opacity(opacity)
                    .shimmering()
                    .animation(.easeInOut)
                
               
            }
            
            TextField("  Search by city or world", text: $vm.searchTerm, onCommit:  {
                vm.performSearch()
            })
                .placeholder(when: vm.searchTerm.isEmpty) {
                    Text("  Search by city or world").foregroundColor(.gray)
            }
            .frame(height: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white, lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .animation(.easeOut)
            
            
            
                CardStack(direction: LeftRight.direction,
                          data: vm.newSecretSpots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser}), id: \.self) { spot, direction in
                    
                    switch direction {
                    case .right:
                        saveCardToUserWorld(spot: spot)
                      
                    case .left:
                        dismissCard(spot: spot)
                    }
                    
                } content: { spot, direction, isOnTop in
               
                    CardView(spot: spot)
                    
                }
                .offset(x: 20)
          

            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.seal")
                    .font(.largeTitle)
            })
                .padding(.bottom, 10)

            Spacer()
            
        }
        .background(Color.dark_grey)
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showAlert, content: {
            guard let wallet = wallet else {return Alert(title: Text("Error Finding Wallet"))}
            let title = Text("Insufficient StreetCred").foregroundColor(.red)
            let message = Text("Your wallet has a balance of \(wallet) STC. \n Post a secret spot to earn more StreetCred.")
            return Alert(title: title, message: message, dismissButton: .cancel(Text("Ok")))
        })
        .onAppear {
            guard let wallet = wallet else {return}
            let walletStatement = "\(wallet) StreetCred Remaining"
            captions[2] = walletStatement
        }
        //End of Body
    }
    
    fileprivate func saveCardToUserWorld(spot: SecretSpot) {
        guard var wallet = wallet else {return}
        
        if wallet >= spot.price {
            //Decremement wallet locally
            wallet -= spot.price
            UserDefaults.standard.set(wallet, forKey: CurrentUserDefaults.wallet)
            print("Saving to user's world")
            saved = true
            //Save to DB
            DataService.instance.saveToUserWorld(spot: spot) { success in
                
                if !success {
                    print("Error saving to user's world")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        saved.toggle()
                    }
                    return
                }
                print("successfully saved spot to user's world")
                AnalyticsService.instance.savedSecretSpot()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    saved.toggle()
                }
            }
            
         
        } else {
            showAlert.toggle()
        }
        
        //Check if spot is last, if true dismiss view
        guard let index = vm.newSecretSpots.firstIndex(of: spot) else {return}
        if index  == vm.newSecretSpots.count - 1 {
            opacity = 1
            complete.toggle()
            vm.hasNewSpots = false
            //Use the last secret spot to start the next query
            vm.lastSecretSpot = vm.newSecretSpots.last?.id ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    fileprivate func dismissCard(spot: SecretSpot) {
        print("Removing from user's world")
        passed = true
        
        DataService.instance.dismissCard(spot: spot) { success in
            if !success {
                print("Error dismissing card")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    passed.toggle()
                }
                return
            }
            print("successfully saved dismissed card to DB")
            AnalyticsService.instance.passedSecretSpot()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                passed.toggle()
            }
        }
        
        guard let index = vm.newSecretSpots.firstIndex(of: spot) else {return}
        if index  == vm.newSecretSpots.count - 1{
            opacity = 1
            complete.toggle()
            vm.lastSecretSpot = vm.newSecretSpots.last?.id ?? ""
            vm.hasNewSpots = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
    }
    
   
    
    

}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView(vm: MissionViewModel())
    }
}
