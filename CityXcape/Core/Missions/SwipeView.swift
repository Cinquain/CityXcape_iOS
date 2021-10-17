//
//  SwipeView.swift
//  CityXcape
//
//  Created by James Allan on 10/8/21.
//

import SwiftUI
import CardStack

struct SwipeView: View {
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @Environment(\.presentationMode) var presentationMode

    
    @StateObject var vm: MissionViewModel = MissionViewModel()
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 0
    @State private var currentSpot: SecretSpot?
    @State private var passed: Bool = false
    @State private var saved: Bool = false
    @State private var complete: Bool = false
    private var threshold: CGFloat = 155
    var body: some View {
        let captions: [String] = [
            "Save the spots you want to visit",
            "Swipe right to save mission",
            "Swipe left to pass on it",
        ]
    
        VStack {
            Ticker(profileUrl: profileUrl ?? "", captions: captions)
                .padding(.top, 25)
                .frame(height: 120)
 
            Image("Scout")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 100)
                .opacity(0.1)
            
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

       
            
                CardStack(direction: LeftRight.direction,
                  data: vm.userMissions, id: \.self) { spot, direction in
                    
                    switch direction {
                    case .right:
                        saveCardToUserWorld(spot: spot)
                    case .left:
                        dismissCard(spot: spot)
                    }
                    
                } content: { spot, direction, isOnTop in
                    CardView(spot: spot)
                }
                .offset(x: 40)
            
            Spacer()
            
        }
        .background(Color.dark_grey)
        .edgesIgnoringSafeArea(.all)
    }
    
    
    fileprivate func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset.width)
        let percentage = currentAmount / max
        return 1.0 - min(percentage, 0.5) * 0.5
    }
    
    fileprivate func getRotationAmount() -> Double {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = offset.width
        let percentage = currentAmount / max
        let percentageAsDouble = Double(percentage)
        let maxAngle: Double = 10
        return percentageAsDouble * maxAngle
    }
    
    fileprivate func saveCardToUserWorld(spot: SecretSpot) {
        print("Saving to user's world")
        saved = true
        
        guard let index = vm.userMissions.firstIndex(of: spot) else {return}
        if index  == vm.userMissions.count - 1 {
            opacity = 1
            complete.toggle()
            vm.hasUserMissions = false
            vm.lastSecretSpot = vm.userMissions.last?.postId ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
      
        DataService.instance.saveToUserWorld(spot: spot) { success in
            
            if !success {
                print("Error saving to user's world")
                saved.toggle()
                return
            }
            
            saved.toggle()
        }
    }
    
    fileprivate func dismissCard(spot: SecretSpot) {
        print("Removing from user's world")
        passed = true
        
        guard let index = vm.userMissions.firstIndex(of: spot) else {return}
        if index  == vm.userMissions.count - 1{
            opacity = 1
            complete.toggle()
            vm.lastSecretSpot = vm.userMissions.last?.postId ?? ""
            vm.hasUserMissions = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
      
        DataService.instance.dismissCard(spot: spot) { success in
            if !success {
                print("Error dismissing card")
                passed.toggle()
                return
            }
            
            passed.toggle()
            
        }
        
    }
    
    

}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView()
    }
}
