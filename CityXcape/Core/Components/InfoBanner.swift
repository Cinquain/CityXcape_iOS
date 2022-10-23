//
//  InfoBanner.swift
//  CityXcape
//
//  Created by James Allan on 10/22/22.
//

import SwiftUI

struct InfoBanner: View {
    var infos: [String] = [
    "Find people in your world",
    "Touch dot to view user profile",
    "Send friend request to message"
    ]
    @State var timer: Timer?
    @State var index: Int = 0
    var width: CGFloat = UIScreen.screenWidth
    var body: some View {
       
        
        HStack(spacing: 5){
                Image("cx-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .padding(.leading, 20)

                Text(infos[index])
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .background(.black)
                    .animation(.easeOut(duration: 0.3), value: index)
                Spacer()
            }
            .frame(width: width - 40, height: 50)
            .background(.black)
            .clipShape(Capsule())
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
        
    }
    
    fileprivate func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            if index == infos.count - 1 {
                index = 0
            }
            index += 1
            
        }
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
    }
}

struct InfoBanner_Previews: PreviewProvider {
    static var previews: some View {
        InfoBanner()
            .previewLayout(.sizeThatFits)
    }
}
